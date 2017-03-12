const Meta = imports.gi.Meta;

let custom_focused_shadow_params = [], custom_unfocused_shadow_params = [];
let old_focused_shadow_params = [], old_unfocused_shadow_params = [];
let shadow_factory;
let shadow_classes;

function init() {
    custom_focused_shadow_params["normal"] =          new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity: 128});
    custom_focused_shadow_params["dialog"] =          new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity: 128});
    custom_focused_shadow_params["modal_dialog"] =    new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity: 128});
    custom_focused_shadow_params["utility"] =         new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity: 128});
    custom_focused_shadow_params["border"] =          new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity: 128});
    custom_focused_shadow_params["menu"] =            new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity: 128});
    custom_focused_shadow_params["popup-menu"] =      new Meta.ShadowParams({radius: 0, top_fade:  0, x_offset: 0, y_offset: 0, opacity: 128});
    custom_focused_shadow_params["dropdown-menu"] =   new Meta.ShadowParams({radius: 0, top_fade: 10, x_offset: 0, y_offset: 0, opacity: 128});
    custom_focused_shadow_params["attached"] =        new Meta.ShadowParams({radius: 0, top_fade:  0, x_offset: 0, y_offset: 0, opacity: 128});

    custom_unfocused_shadow_params["normal"] =        new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity:  32});
    custom_unfocused_shadow_params["dialog"] =        new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity:  32});
    custom_unfocused_shadow_params["modal_dialog"] =  new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity:  32});
    custom_unfocused_shadow_params["utility"] =       new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity:  32});
    custom_unfocused_shadow_params["border"] =        new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity:  32});
    custom_unfocused_shadow_params["menu"] =          new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity:  32});
    custom_unfocused_shadow_params["popup-menu"] =    new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity: 128});
    custom_unfocused_shadow_params["dropdown-menu"] = new Meta.ShadowParams({radius: 0, top_fade: 10, x_offset: 0, y_offset: 0, opacity: 128});
    custom_unfocused_shadow_params["attached"] =      new Meta.ShadowParams({radius: 0, top_fade: -1, x_offset: 0, y_offset: 0, opacity: 128});

    shadow_classes = ["normal", "dialog", "modal_dialog", "utility", "border", "menu", "popup-menu", "dropdown-menu", "attached"];

    shadow_factory = Meta.ShadowFactory.get_default();
}

function enable() {
    for (i = 0; i < shadow_classes.length; i++) {
        let shadow_class = shadow_classes[i];
        old_focused_shadow_params[shadow_class] = shadow_factory.get_params(shadow_class, true);
        old_unfocused_shadow_params[shadow_class] = shadow_factory.get_params(shadow_class, false);
        shadow_factory.set_params(shadow_class, true, custom_focused_shadow_params[shadow_class]);
        shadow_factory.set_params(shadow_class, false, custom_unfocused_shadow_params[shadow_class]);
    }
}

function disable() {
    for (i = 0; i < shadow_classes.length; i++) {
        let shadow_class = shadow_classes[i];
        shadow_factory.set_params(shadow_class, true, old_focused_shadow_params[shadow_class]);
        shadow_factory.set_params(shadow_class, false, old_unfocused_shadow_params[shadow_class]);
    }
}
