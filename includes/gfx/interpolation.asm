/**
 * @file interpolation.asm
 *
 * Various functions for rendering interpolation data with easing.
 *
 * For examples of interpolation types see: https://easings.net/
 *
 * Based on Robert Penner's Easing Functions, see: http://robertpenner.com/easing/
 * Original source by Jesús Gollonet, see: https://github.com/jesusgollonet/processing-penner-easing/
 *
 * Open source under the BSD License, see: http://www.opensource.org/licenses/bsd-license.php
 *
 * Copyright 2001 Robert Penner
 * All rights reserved.
 *
 * For license details see LICENSE.md file at root directory.
 **/

#importonce

#import "internal/gfx/interpolation.asm"

/**
 * Ease when in.
 **/
.const GFX_INTERPOLATION_WHEN_EASE_IN = 0

/**
 * Ease when out.
 **/
.const GFX_INTERPOLATION_WHEN_EASE_OUT = 1

/**
 * Ease when in and out.
 **/
.const GFX_INTERPOLATION_WHEN_EASE_IN_OUT = 2

/*
 * Interpolation: back.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Back(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0
    .const s = 1.70158

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return c*(t/=d)*t*((s+1)*t - s) + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .if ((t/=d/2) < 1) {
        .return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b
    }

    .return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b
}

/*
 * Interpolation: bounce
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Bounce(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return Internal_Gfx_Interpolation_Bouce_EaseIn(t, b, c, d)
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return Internal_Gfx_Interpolation_Bouce_EaseOut(t, b, c, d)
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .return Internal_Gfx_Interpolation_Bouce_EaseInOut(t, b, c, d)
}


/*
 * Interpolation: circular.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Circular(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return -c * (sqrt(1 - (t/=d)*t) - 1) + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return c * sqrt(1 - (t=t/d-1)*t) + b
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .if ((t/=d/2) < 1) {
        .return -c/2 * (sqrt(1 - t*t) - 1) + b
    }

    .return c/2 * (sqrt(1 - (t-=2)*t) + 1) + b
}


/*
 * Interpolation: cubic.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Cubic(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return c*(t/=d)*t*t + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return c*((t=t/d-1)*t*t + 1) + b
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .if ((t/=d/2) < 1) {
        .return c/2*t*t*t + b
    }

	.return c/2*((t-=2)*t*t + 2) + b
}


/*
 * Interpolation: elastic.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Elastic(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .if (t==0) {
            .return b
        }

        .if ((t/=d)==1) {
            .return b+c
        }

        .const p=d*0.3
        .const a=c 
        .const s=p/4
        .return -(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*PI)/p )) + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .if (t==0) {
            .return b
        }

        .if ((t/=d)==1){
            .return b+c
        }

       .const p=d*0.3
       .const a=c
       .const s=p/4
        .return (a*pow(2,-10*t) * sin( (t*d-s)*(2*PI)/p ) + c + b)
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .if (t==0){
        .return b
    }

    .if ((t/=d/2)==2){
        .return b+c
    }

    .const p=d*(0.3*1.5)
    .const a=c
    .const s=p/4
    .if (t < 1) {
        .return -0.5*(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*PI)/p )) + b
    }

    .return a*pow(2,-10*(t-=1)) * sin( (t*d-s)*(2*PI)/p )*0.5 + c + b
}


/*
 * Interpolation: expo.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Expo(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .if (t==0) {
        .return b
    }
    
    .if (t==d) {
        .return b+c
    }
    
    .if ((t/=d/2) < 1) {
        .return c/2 * pow(2, 10 * (t - 1)) + b
    }
    
    .return c/2 * (-pow(2, -10 * (t - 1)) + 2) + b
}


/*
 * Interpolation: linear.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 */
.function Gfx_Interpolation_Linear(value, start, stop) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .return c*t/d + b
}


/*
 * Interpolation: quad.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Quad(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return c*(t/=d)*t + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return -c *(t/=d)*(t-2) + b
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .if ((t/=d/2) < 1) {
        .return c/2*t*t + b
    }

    .return -c/2 * ((t-1)*(t-2) - 1) + b
}


/*
 * Interpolation: quart.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Quart(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return c*(t/=d)*t*t*t + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return -c * ((t=t/d-1)*t*t*t - 1) + b
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .if ((t/=d/2) < 1) {
        .return c/2*t*t*t*t + b
    }

    .return -c/2 * ((t-=2)*t*t*t - 2) + b
}


/*
 * Interpolation: quint.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Quint(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return c*(t/=d)*t*t*t*t + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return c*((t=t/d-1)*t*t*t*t + 1) + b
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .if ((t/=d/2) < 1) {
        .return c/2*t*t*t*t*t + b
	}

	.return c/2*((t-=2)*t*t*t*t + 2) + b
}


/*
 * Interpolation: sine.
 *
 * @param value floating value to map between [0..1].
 * @param start lower limit of the output range.
 * @param stop upper limit of the output range.
 * @param when when to ease, one of GFX_INTERPOLATION_WHEN_* constants.
 */
.function Gfx_Interpolation_Sine(value, start, stop, when) {
    .var b = start
    .var c = stop - start
    .var t = value
    .var d = 1.0

    .eval Internal_Gfx_Interpolation_CheckEaseType(when)

    .if (when == GFX_INTERPOLATION_WHEN_EASE_IN) {
        .return -c * cos(t/d * (PI/2)) + c + b
    }

    .if (when == GFX_INTERPOLATION_WHEN_EASE_OUT) {
        .return c * sin(t/d * (PI/2)) + b
    }

    //GFX_INTERPOLATION_WHEN_EASE_IN_OUT
    .return -c/2 * (cos(PI*t/d) - 1) + b
}