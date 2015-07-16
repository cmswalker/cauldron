// zooming on mouse cursor with adjusting -transform-origin
// moving the zooming frame with the -transfrorm matrix 

/***************************************************** 
 * Transformations
 ****************************************************/
function Transformations(originX, originY, translateX, translateY, scale){
    this.originX = originX;
    this.originY = originY;
    this.translateX = translateX;
    this.translateY = translateY;
    this.scale = scale;
}

/* Getters */
Transformations.prototype.getScale = function(){ return this.scale; }
Transformations.prototype.getOriginX = function(){ return this.originX; }
Transformations.prototype.getOriginY = function(){ return this.originY; }
Transformations.prototype.getTranslateX = function(){ return this.translateX; }
Transformations.prototype.getTranslateY = function(){ return this.translateY; }

/***************************************************** 
 * Zoom Pan Renderer
 ****************************************************/
function ZoomPanRenderer(elementId){
    this.zooming = undefined;
    this.elementId = elementId;
    this.current = new Transformations(0, 0, 0, 0, 1);
    this.last = new Transformations(0, 0, 0, 0, 1);
    new ZoomPanEventHandlers(this);
}

/* setters */
ZoomPanRenderer.prototype.setCurrentTransformations = function(t){ this.current = t; }
ZoomPanRenderer.prototype.setZooming = function(z){ this.zooming = z; }

/* getters */
ZoomPanRenderer.prototype.getCurrentTransformations = function(){ return this.current; }
ZoomPanRenderer.prototype.getZooming = function(){ return this.zooming; }
ZoomPanRenderer.prototype.getLastTransformations = function(){ return this.last; }
ZoomPanRenderer.prototype.getElementId = function(){ return this.elementId; }

/* Rendering */
ZoomPanRenderer.prototype.getTransform2d = function(t){
    var transform2d = "matrix(";
    transform2d+= t.getScale().toFixed(1) + ",0,0," + t.getScale().toFixed(1) + "," + t.getTranslateX().toFixed(1) +"," + t.getTranslateY().toFixed(1) + ")";
    //0,0)";
    return transform2d;
}

ZoomPanRenderer.prototype.applyTransformations = function(t){
    var elem = $("#" + this.getElementId());
    var orig = t.getOriginX().toFixed(10) + "px " + t.getOriginY().toFixed(10) + "px";
    elem.css("transform-origin", orig);
    elem.css("-ms-transform-origin", orig);
    elem.css("-o-transform-origin", orig);
    elem.css("-moz-transform-origin", orig);
    elem.css("-webkit-transform-origin", orig);
    var transform2d = this.getTransform2d(t);
    elem.css("transform", transform2d);
    elem.css("-ms-transform", transform2d);
    elem.css("-o-transform", transform2d);
    elem.css("-moz-transform", transform2d);
    elem.css("-webkit-transform", transform2d);
}

/***************************************************** 
 * Event handler
 ****************************************************/
function ZoomPanEventHandlers(renderer){
    this.renderer = renderer;

    /* Disable scroll overflow - safari */
    document.addEventListener('touchmove', function(e) { e.preventDefault(); }, false);

    /* Disable default drag opeartions on the element (FF makes it ready for save)*/
    $("#" + renderer.getElementId()).bind('dragstart', function(e) { e.preventDefault(); });

    /* Add mouse wheel handler */
    $("#" + renderer.getElementId()).bind("mousewheel", function(event, delta) {
        if(renderer.getZooming()==undefined){
            var offsetLeft = $("#" + renderer.getElementId()).offset().left;
            var offsetTop = $("#" + renderer.getElementId()).offset().top;
            var zooming = new MouseZoom(renderer.getCurrentTransformations(), event.pageX, event.pageY, offsetLeft, offsetTop, delta);
            renderer.setZooming(zooming);

            var newTransformation = zooming.zoom();
            renderer.applyTransformations(newTransformation);
            renderer.setCurrentTransformations(newTransformation);
            renderer.setZooming(undefined);
        }
        return false;
    });
}

/***************************************************** 
 * Mouse zoom
 ****************************************************/
function MouseZoom(t, mouseX, mouseY, offsetLeft, offsetTop, delta){
    this.current = t;
    this.offsetLeft = offsetLeft;
    this.offsetTop = offsetTop;
    this.mouseX = mouseX;
    this.mouseY = mouseY;
    this.delta = delta;
}

MouseZoom.prototype.zoom = function(){
    // current scale
    var previousScale = this.current.getScale();
    // new scale
    var newScale = previousScale + this.delta/10;
    // scale limits
    var maxscale = 20;
    if(newScale<1){
        newScale = 1;
    }
    else if(newScale>maxscale){
        newScale = maxscale;
    }
    // current cursor position on image
    var imageX = (this.mouseX - this.offsetLeft).toFixed(2);
    var imageY = (this.mouseY - this.offsetTop).toFixed(2);
    // previous cursor position on image
    var prevOrigX = (this.current.getOriginX()*previousScale).toFixed(2);
    var prevOrigY = (this.current.getOriginY()*previousScale).toFixed(2);
	// previous zooming frame translate
	var translateX = this.current.getTranslateX();
    var translateY = this.current.getTranslateY();
	// set origin to current cursor position
	var newOrigX = imageX/previousScale;
    var newOrigY = imageY/previousScale;
    
    // move zooming frame to current cursor position
    if ((Math.abs(imageX-prevOrigX)>1 || Math.abs(imageY-prevOrigY)>1) && previousScale < maxscale) {
        translateX = translateX + (imageX-prevOrigX)*(1-1/previousScale);
        translateY = translateY + (imageY-prevOrigY)*(1-1/previousScale);
    }
    // stabilize position by zooming on previous cursor position
    else if(previousScale != 1 || imageX != prevOrigX && imageY != prevOrigY) {
        newOrigX = prevOrigX/previousScale;
        newOrigY = prevOrigY/previousScale;
            //frame limit
    }
    // on zoom-out limit frame shifts to original frame
        if(this.delta <= 0){
            var width = 500;
            var height = 350;
            if(translateX+newOrigX+(width - newOrigX)*newScale <= width){
                translateX = 0;
                newOrigX = width;
            }
            else if (translateX+newOrigX*(1-newScale) >= 0){
                translateX = 0;
                newOrigX = 0;        
            }
            if(translateY+newOrigY+(height - newOrigY)*newScale <= height){
                translateY = 0;
                newOrigY = height;
            }
            else if (translateY+newOrigY*(1-newScale) >= 0){
                translateY = 0;
                newOrigY = 0;
            }
        }

    return new Transformations(newOrigX, newOrigY, translateX, translateY, newScale);
}

var renderer = new ZoomPanRenderer("frame2");