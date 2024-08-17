//--------------------- Interals or gx/interpolation
#importonce

.function Internal_Gfx_Interpolation_CheckEaseType(type) {

    .var easeParams = Hashtable().put(
            GFX_INTERPOLATION_WHEN_EASE_IN, 0,
            GFX_INTERPOLATION_WHEN_EASE_OUT, 0,
            GFX_INTERPOLATION_WHEN_EASE_IN_OUT, 0
    )

    .if (!easeParams.containsKey(type)) {
        .error "Unrecognised ease when parameter: " + type
    }

}

.function Internal_Gfx_Interpolation_Bouce_EaseOut(t, b, c, d) {
    .if ((t/=d) < (1/2.75)) {
        .return c*(7.5625*t*t) + b
    }
		
   .if (t < (2/2.75)) {
        .return c*(7.5625*(t-=(1.5/2.75))*t + 0.75) + b
    }

    .if (t < (2.5/2.75)) {
        .return c*(7.5625*(t-=(2.25/2.75))*t + 0.9375) + b
    }

    .return c*(7.5625*(t-=(2.625/2.75))*t + 0.984375) + b
}

.function Internal_Gfx_Interpolation_Bouce_EaseIn(t, b, c, d) {
    .return c - Internal_Gfx_Interpolation_Bouce_EaseOut(d-t, 0, c, d) + b
}

.function Internal_Gfx_Interpolation_Bouce_EaseInOut(t, b, c, d) {
    .if (t < d/2) {
        .return Internal_Gfx_Interpolation_Bouce_EaseIn(t*2, 0, c, d) * 0.5 + b
    }
    
    .return Internal_Gfx_Interpolation_Bouce_EaseOut(t*2-d, 0, c, d) * 0.5 + c*0.5 + b
}