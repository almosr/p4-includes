
//Adds a character defintion to the specified list,
//when a definition exists at the requested position then throws an error.
.function Internal_Gfx_Image_Charset_Add(list, source, position, index) {
    .if ("" + list.get(position) != "Null") .error "Duplicate character definition, character index: " + position
    .eval list.set(position, Char(source, index))
}