# A set of macros for obtaining a list of dimensions from an AutoCAD drawing.

Includes AutoCAD macros (in AutoLISP - .lsp) and subsequent Excel macros (.xlsm).
Creates new Excel file(s) with calculated dimensions for selected layers.

Works with drawings of cross sections, and from 2022/08 also with plan drawings (using separate files).

Detailed description and workflow is described in the attached .docx file, in Czech.

## Versions:

1.0 first set of .lsp and .xlsm files, with manual in .docx (2021/01)

2.0 .xlsm distinguishes whether a layer contains areas or lengths based on the layer's name; manual updated (2021/11)

2.1 compared to the previous version, the workbook allows not to specify the dimension in the layer's name, in that case it shows both volume and area as a result for the layer, just like the original version. Stationing of cross sections in the drawing is accepted both as "text" and "mtext" - new .lsp as well (2022/02)