=============
Inicio Rapido
=============

.. sectionauthor:: `jryannel <https://github.com/jryannel>`_, `Carlos Hernandez <https://github.com/CharlieGearsTech>`_

.. issues:: ch04

.. note::

    Last Build: |today|

    El codigo fuente de este capitulo puede ser encontrado en:  <../../assets>`_.


Este capitulo provee un vistazo a QML, el lenguaje de interfaz de usuario declarativo usado en Qt 5. Vamos a discutir la sintaxis de QML, que es una jerarquia tipo árbol de elementos, siguiendo un vistazo de los elementos básicos mas importantes. Después de eso, tendremos un vistazo rápido a como crear nuestros propios elementos, llamados componentes y como transformar elementos usando manipuladores de propiedades. Hacia el final, tendremos un vistazo a como colocar elementos juntos en un "layout" y finalmente checar los elementos donde el usuario provee entradas.

Sintaxis de QML
===============

.. issues:: ch04

.. index:: qmlscene, properties, scripting, binding, syntax

QML es un lenguaje declarativo usado para describir interfaces de usuario en tu aplicación. Separa la interfaz de usuario dentro de elementos mas pequeños, cuales pueden ser combinados como componentes. QML describe la vista y el comportamiento de estos elementos de interfaz de usuario. Esta descripción de interfaz de usuario puede ser enriquecido con código de JavaScript para proveer una lógica simple pero mas compleja. En esta perspectiva, QML sigue el patrón de HTML-JavaScript pero QML esta diseñado desde cero para describir interfaces de usuario y no documentos de texto.

QML, en su forma mas fácil, es una jerarquía de elementos. Elementos hijos heredan el sistema de coordenadas del padre. Una coordenada ``x,y``  es siempre relativa a su padre.

.. figure:: assets/scene.png

Empecemos con un ejemplo simple de un archivo QML para explicar las diferentes sintaxis.

.. literalinclude:: src/concepts/RectangleExample.qml
    :start-after: M1>>
    :end-before: <<M1

* La palabra ``import`` importa un modulo de una versión especifica. En general, tu siempre querrás importar desde *QtQuick 2.0* (o versiones superiores) como un conjunto inicial de elementos.
* Comentarios pueden ser realizadas usando ``//`` para comentarios de un solo renglón o ``/* */`` para comentarios de múltiples lineas. Similar como C/C++ y JavaScript..
* Cada archivo QML necesita tener unicamente un elemento base, como HTML.
* Un elemento es declarado por su tipo seguido con ``{ }``
* Elementos pueden tener propiedades, las propiedades están en la forma ``nombre : valor``
* Elementos arbitrarios adentro de un documento QML pueden ser accedidos usando su propiedad ''id'' (un identificador sin comillas).
* Elementos pueden ser anidados, refiriéndose a que un elemento padre puede tener varios elementos hijos. El elemento padre puede ser accedido usando la palabra ''parent''.

.. tip::

		Normalmente tu querras acceder un elemento en particular por el id, o un elemento padre usando la palabra ``parent``. Es una buena practica llamar tu elemento base como "root" o "base" usando ``id: root``. ENtonces no tendras que pensar acerca de como los elementos base son llamados en tu documento QML.

.. hint::

	Puedes ejecutar un ejemplo usando el runtime de Qt Quick desde la linea de comandos de tu OS como este:

		$ $QTDIR/bin/qmlscene RectangleExample.qml

	Donde necesitas reemplazar la palabra *$QTDIR* con la dirección de tu instalación de Qt. El ejecutable *qmlscene* inicializa el runtime de Qt Quick e interpreta el archivo QML que se proveo.

	In Qt Creator puedes abrir el proyecto correspondiente y ejecutar el documento ''RectangleExample.qml''

Propiedades
----------

.. issues:: ch04

Elementos son declarados usando sus nombres, pero son definidos usando sus propiedades, o creando propiedades personalizadas. Una propiedad es un par simple de llave-valor, por ejemplo: ``width : 100``, ``text: 'Greetings'``, ``color: '#FF0000'``. Una propiedad tiene un tipo bien definido y puede tener un valor inicial.

.. literalinclude:: src/concepts/PropertiesExample.qml
    :start-after: M1>>
    :end-before: <<M1
Veamos las diferentes caracteristicas de las propiedades:

(1) ''id'' es una propiedad bastante especial, es usado para hacer referencia a elementos adentro de un archivo QML (llamado "documento" en QML). El ''id'' no es tipo string, si no un identificador y parte de la sintaxis de QML. Un ''id'' necesita ser unico adentro de un documento y no puede agregar otro valor ya ingresado, y no debería ser encolado. (id se comporta más como un puntero en el mundo de C++).

(2) Una propiedad puede obtener un valor, dependiendo del tipo. Si un valor no fue dado a una propiedad un valor inicial va a ser seleccionado. Necesitas consultar la documentación de un elemento en particular para más información acerca de su valor inicial.

(3) Una propiedad puede depender de uno u otras propiedades. Esto es llamado *enlazamiento*. Una propiedad enlazada es actualizada, cuando la propiedad dependiente cambia. Funciona como un contrato, en este caso ``height``siempre debe de ser 2 veces el ``width``.

(4) Puedes agregar tus propias propiedades a un elemento usando el cualificador ``property`` seguido con su tipo, el nombre y un valor inicial optional (``property <type> <name> : <value>``). Si un valor inicial no es dado, entonces un valor inicial del sistema es seleccionado.

.. note:: También puedes declarar una propiedad para ser una propiedad por default si no se definió un nombre de propiedad, esto se realiza agregando al inicio de una declaración de propiedad la palabra ''default''. Esto es usado, por ejemplo cuando se agrega elementos hijos, el elemento hijo es agregado automáticamente para la propiedad por default ''children'' de la lista de tipos si este tipo es visible a los elementos.

(5) Otra manera importante de declarar propiedades es usando la palabra ``alias`` ``property alias <nombre> : <referencia>``). La palabra ''alias'' nos permite adelantar una propiedad de un objecto o un objeto en si desde adentro del tipo a un alcance externo. Vamos a usar esta técnica después cuando definamos componentes para exportar las propiedades internas o id de elementos para un nivel del componente base. Un alias de propiedad no necesita un tipo, usa el tipo de la propiedad o objecto referenciado.

(6) La propiedad ''text'' depende en la propiedad personalizada ''times'' de tipo int. El valor basado en ''int'' es convertido automáticamente a un tipo ''string''. La expresión en si es otro ejemplo de enlazamiento y resulta en el texto actualizándose cada vez que la propiedad ''times'' cambia.

(7) Algunas propiedades son propiedades agrupadas. Este es un rasgo que es usado cuando una propiedad esta más estructurada y propiedades relacionadas entre si deberían ser agrupadas. Por ejemplo, otra forma de escribir en propiedades agrupadas es ''font { family: "Ubuntu"; pixelSize: 24 }''.

(8) Algunas propiedades están relacionadas con un solo elemento. Esto está hecho para elementos de relevancia global cuales aparecen solamente una vez en la aplicación (por ejemplo, entrada de teclado). La escritura es ``<Element>.<property>: <value>``.

(9) Para cada propiedad puedes proveer un manejador de señal. Este manejador es llamado después de los cambios de una propiedad. Por ejemplo, aquí queremos ser notificados en cualquier momento de los cambios en la altura del rectángulo, y así usar una consola para registrar un mensaje al sistema.

.. warning:: Un id de un elemento debe ser usado unicamente como referencia de elementos dentro de tu documento ( tu archivo actual). QML provee un mecanismo llamado "alcance dinámico" donde recientes documentos cargados sobrescriben los ids de documentos mas antiguos. Esto hace posible hacer referencia a ids de elementos en los documentos antiguos, si estos no han sido sobrescritos. Es como crear variables globales. Desafortunadamente, esto frecuentemente nos lleva a realizar malas practicas de código, donde el programa depende de la orden de ejecución. Desafortunadamente esto no puede apagarse. Usa este rasgo con cuidado o mejor no lo uses. Es mejor exportar elementos que quieres ofrecer al mundo exterior usando propiedades en los elementos de la base de tu documento.

Scripting
---------

.. issues:: ch04

QML y JavaScript (tambien conocido como ECMAScript) son los mejores amigos. En el capitulo de *JavaScript* vamos a ir más en detalle en este simbiosis. Actualmente queremos hacer notar esta relación.

.. literalinclude:: src/concepts/ScriptingExample.qml
    :start-after: M1>>
    :end-before: <<M1

(1) El manipulador de cambios de texto ``onTextChanged`` imprime el texto actual cada vez que este texto cambia debido a que se presiona la barra espaciadora.

(2) Cuando el elemento texto recibe un click de la barra espaciadora (porque el usuario presiono la barra espaciadora en el teclado) llamamos una funcion JavaScript ``increment()``.

(3) Definición de una funcion JavaScript en la forma de ``function <name>(<parameters>) { ... }``, cual incrementa nuestro contador ``spacePressed``. Cada vez que ``spacePressed`` incrementa, las propiedades enlazadas se actualizaran.

.. note:: La diferencia entre QML ``:`` (enlace) y de JavaScript ``=``( asignacion) es, que que el enlace es un contrato y continua siendo verdad durante la vida del enlace, miestras que la asignacion de JavaScript es una asignacion de valor de un solo tiempo.
		La vida de enlaces terminan cuando un nuevo enlace es puesto en la propiedad o incluso cuando un valor JavaScript es asignado a la propiedad. Por ejemplo la puesta de una propiedad de texto en el manipular de text a una cadena vacia podria destruir nuestro despliegue de increment

        Keys.onEscapePressed: {
        label.text = ''
    		}
		
		Despues de presionar escape, el presionar la barra espaciadora no actualizara la vista otra vez, debido a que el enlace de la propiedad ``text`` (*text: "Space pressed: " + spacePresses + " times"*) ha sido destruido.

		Cuando tienes conflicto en estrategias para cambiar una propiedad como en este caso (texto actualizado por un cambio de un incremento de una propiedad por un enlace y limpieza de texto por un asignación de JavaScript) no podrás usar enlaces! Necesitas usar asignación en las dos patrones de cambios de propiedades, ya que el enlace sera destruido por la asignación (contrato roto!).

Elementos Basicos
==============

.. issues:: ch04

.. index:: Item, Rectangle, Text, MouseArea, Image, gradients

Elementos pueden ser agrupados dentro de elementos visuales y no visuales. Un elemento visual (como ``Rectangle``) tiene una geometria y normalmente se presenta en un area del monitor. Un elemento no visual (como un``Timer``) provee una funcionalidad general, normalmente usado para manipular elementos visuales. 

Actualmente, nos enfocaremos en elementos visuales fundamentales, tales como `Item``, ``Rectangle``, ``Text``, ``Image`` y ``MouseArea``.

Elemento Item
------------

.. issues:: ch04

``Item`` es un elemento base para todo elemento visual, tal como los otros elementos visuales heredan de ``Item``. No pinta nada más que el mismo pero define todas las propiedades que son comunes entre todos los elementos visuales.

.. list-table::
    :widths: 20,80
    :header-rows: 1

    *   - Grupo
        - Propiedades
    *   - Geometría
        - ``x`` y ``y`` para definir el extremo superior-izquierdo, ``width`` y ``height`` para expander el elemento y  ``z`` para sobreponer elementos entre si arriba y abajo para modificar su orden natural.
    *   - Manejador de planos
        - ``anchors`` (izquierda, derecha, arriba, abajo, centro vertical y horizontal) para posicionar elementos entre ellos con sus ``margins``.
    *   - Manejador de teclado
        - embebido en las propiedades ``Key`` y ``KeyNavigation`` para controlar manejo de teclado y la entrada, la propiedad ``focus`` para permitir este manejo de teclado.
    *   - Transformación
        - ``scale`` y ``rotate`` transformaciones y la lista de propiedades generica ``transform`` para transformaciones en *x,y,z* y sus puntos de ``transformOrigin``.
    *   - Visual
        - ``opacity`` para controlar transparencia, ``visible`` para mostrar/ocultar elementos, ``clip`` para restringir operaciones de pintado para el perímetro del elemento y ``smooth`` para mejorar la calidad de render.
    *   - Definición de estado
        - La lista de propiedades ``states`` con soporte de listas de estados y la propiedad del actual ``state`` como también la lista de propiedades ``transitions`` para animar cambios entre estados.

Para mejorar el aprendizaje de las diferentes propiedades, trataremos de introducirlos dentro de este capitulo en el contexto de los elementos presentados. Recuerda que estas propiedades fundamentales están disponibles en cada elemento visual y trabajan igual entre estos elementos.

.. note::

    El elemento ``Item`` es normalmente usado como contenedor de otros elementos, similar al elemento *div* en HTML.

Elemento Rectangulo
-----------------

.. issues:: ch04

El elemento ``Rectangle`` extiende ``Item`` y agrega un color a este mismo. Adicionalmente soporta perimetors definido por ``border.color`` y ``border.width``. Para crear un rectangulo achatado puedes usar la propiedad ``radious``. 

.. literalinclude:: src/concepts/RectanglesExample2.qml
    :start-after: M1>>
    :end-before: <<M1

.. figure:: assets/rectangle2.png

.. note::

    Hay nombres de colores que son validos como los nombres de colores de un SVG (ve  http://www.w3.org/TR/css3-color/#svg-color). Puedes proveer colores a QML en diferentes maneras, pero el mas usado es la cadena de RGB ('#FF4444') o un nombre de color (ejemplo: 'white').

Aparte del color de relleno y borde, el rectangulo tambien soporta gradientes personalizados.

.. literalinclude:: src/concepts/RectanglesExample3.qml
    :start-after: M1>>
    :end-before: <<M1

.. figure:: assets/rectangle3.png

Un gradiente es definido como una serie de paradas de gradiente. Cada parada tiene una posición y un color. La posición marca el posicionamiento en el eje y (0 = arriba, 1= abajo). El color de ``GradientStop`` marca el color de esa posición.

.. note::

	Un rectángulo sin *width/height* no sera visible. Esto pasa normalmente cuando tienes bastantes anchos(altos) de los rectángulos dependiendo de las propiedades de los otros rectángulos y algo va mal en tu lógica de composición. Ponte atento!

.. note::

	No es posible el crear un gradiente inclinado. Para esto, es mejor el usar imágenes predefinidas. Una posibilidad puede ser que puedas rotar el rectángulo con el gradiente, pero debes de estar consiente de la geometría de un rectángulo inclinado no cambiara y entonces llegara a confusión cuando la geometría del elemento no es la misma que el área visible. Desde la perspectiva del autor, es mucho mejor el usar imágenes con gradientes diseñados en este caso.

Elementos de Texto
------------

.. issues:: ch04

Para desplegar texto, puedes usar el elemento ``Text``. La propiedad más notable de ``Text`` es la propiedad ``text`` de tipo ``string``. El elemento calcula su ancho y altura inicial basado en el texto y fuente que fue dado. La fuente puede ser modificado usando el grupo de propiedades de font (por ejemplo, ``font.family``,``font.pixelSize``,...). Para cambiar el color del texto solo usa la propiedad ``color``.

.. literalinclude:: src/concepts/TextExample.qml
    :start-after: M1>>
    :end-before: <<M1

|

.. figure:: assets/text.png

Texto puede ser alineado a cada extremo o centro del elemento usando las propiedades ``horizontalAlignment`` y ``verticalAlignment``. Para realzar la calidad del texto puedes usar las propiedades ``style`` y ``styleColor``, cuales te permiten renderizar el texto en modo enlineado, resaltado y sumergido. Para textos más largos, querras definir una posición *break* como * Un extenso... largo texto*, esto puede ser realizado usando la propiedad ``elide``. La propiedad ``elide`` te permite crear una posición de supresión a la izquierda, derecha o en medio de tu texto. En caso de que no quieras el '...' del modo elide para aparecer pero aún quieres ver el texto completo, también puedes envolver el texto usando la propiedad ``wrapMode`` (funciona unicamente cuando el ancho fue puesto explícitamente):

    Text {
        width: 40; height: 120
        text: 'A very long text'
        // '...' deberia aparecer enmedio
        elide: Text.ElideMiddle
        // Estilo de texto sumergido rojo
        style: Text.Sunken
        styleColor: '#FF4444'
        // Alinea el texto hacia arriba
        verticalAlignment: Text.AlignTop
        // Sensible cuando el elide mode no ha sido establecido
        // wrapMode: Text.WordWrap
    }

Un elemento ``Text`` solo despliega el texto dado. No renderiza ninguna decoración del fondo. Por otro lado, el texto renderizado, el elemento ``Text`` es transparente. Es parte del diseño completo para proveer un fondo sensible a los elementos de texto.

.. note::
		Se conciente que el ancho ( y alto) inicial de ``Text`` depende de la cadena de texto y de la fuente establecida. Un elemento ``Text`` que no tiene ancho establecido ni texto, no sera visible, debido a que su ancho inicial va a ser 0.

.. note::

		Normalmente cuando quieres alinear elementos de ``Text`` necesitas diferencias entre alinear el texto dentro del perímetro del rectángulo del elemento ``Text`` o alinear el perímetro del rectángulo por si mismo. En el caso que quieras usar las propiedades ``horizontalAlignment`` y ``verticalAlignment`` en el ultimo caso querrás manipular la geometría del elemento usando anclas.

Elemento de Imagen
-------------

.. issues:: ch04

Un elemento ``Image`` puede desplegar imágenes de varios formatos (ejemplo, PNG, JPG, GIF, BMP, WEBP). * Para la lista completa de los formatos de imagenes soportados, consulta la documentación de Qt*. Aparte de la propiedad obvia ``source`` para proveer la URL de la imagen, ``Image`` contiene una propiedad ``fillMode`` que controla el comportamiento de modificación de tamaño.

.. literalinclude:: src/concepts/ImageExample.qml
    :start-after: M1>>
    :end-before: <<M1

.. figure:: assets/image.png

.. note::

    Una URL puede ser una direccion local con diagonales hacia la derecha ("./images/home.png") o un link de la web (ejemplo "http://example.org/home.png").

.. note::

		Elementos ``Image`` usando la propiedad ``PreserveAspectCrop`` tambien deberan permitir el recorte para evitar que los datos de la imagen sean renderizados afuera del perímetro de ``Image``. Por defecto, recorte esta deshabilitado (``clip: false``). Necesitas permitir recorte (``clip: true``) para contener el pintado de los elementos en su rectángulo de perímetro. Esto puede ser usado en cualquier elemento visual.

.. tip::
		Usando C++, puedes crear tu propio proveedor de imágenes usando : qt%:`QQmlImageProvider <qqmlimageprovider>`. Esto permite crear imágenes al vuelo y enhilar carga de imagen.

MouseArea Element
-----------------

.. issues:: ch04

To interact with these elements you often will use a ``MouseArea``. It's a rectangular invisible item in where you can capture mouse events. The mouse area is often used together with a visible item to execute commands when the user interacts with the visual part.

.. literalinclude:: src/concepts/MouseAreaExample.qml
    :start-after: M1>>
    :end-before: <<M1

.. list-table::
    :widths: 50 50

    *   - .. figure:: assets/mousearea1.png
        - .. figure:: assets/mousearea2.png

.. note::

    This is an important aspect of Qt Quick, the input handling is separated from the visual presentation. By this it allows you to show the user an interface element, but the interaction area can be larger.

Components
==========

.. issues:: ch04

.. index:: components

A component is a reusable element and QML provides different ways to create components. Currently we will look only at the simplest form - a file based component. A file based component is created by placing a QML element in a file and give the file an element name (e.g. ``Button.qml``). You can use the component like every other element from the QtQuick module, in our case you would use this in your code as ``Button { ... }``.

For example, let's create a rectangle containing a text componenet and a mouse area. This resembles a simple button and doesn't need to be more complicated for our purposes.


.. literalinclude:: src/elements/InlinedComponentsExample.qml
    :start-after: M1>>
    :end-before: <<M1

The UI will look similar to this. On the left the UI in the initial state, on the right after the button has been clicked.

.. list-table::
    :widths: 50 50

    *   - .. figure:: assets/button_waiting.png
        - .. figure:: assets/button_clicked.png


Our task is now to extract the button UI in a reusable component. For this we shortly think about a possible API for our button. You can do this by imagining how someone else should use your button. Here's what I came up with:

.. code-block:: js

    // minimal API for a button
    Button {
        text: "Click Me"
        onClicked: { // do something }
    }

I would like to set the text using a ``text`` property and to implement my own click handler. Also I would expect the button to have a sensible initial size, which I can overwrite (e.g. with ``width: 240`` for example).

To achieve this we create a ``Button.qml`` file and copy our button UI inside. Additionally we need to export the properties a user might want to change on the root level.

.. literalinclude:: src/elements/Button.qml
    :start-after: M1>>
    :end-before: <<M1

We have exported the text and clicked signal on the root level. Typically we name our root element root to make the referencing easier. We use the ``alias`` feature of QML, which is a way to export properties inside nested QML elements to the root level and make this available for the outside world. It is important to know, that only the root level properties can be accessed from outside this file by other components.

To use our new ``Button`` element we can simply declare it in our file. So the earlier example will become a little bit simplified.

.. literalinclude:: src/elements/ReusableComponentExample.qml
    :start-after: M1>>
    :end-before: <<M1

Now you can use as many buttons as you like in your UI by just using ``Button { ... }``. A real button could be more complex, e.g providing feedback when clicked or showing a nicer decoration.

.. note::

    Personally you could even go a step further and use an item as a root element. This prevents users to change the color of our designed button, and provides us more control about the exported API. The target should be to export a minimal API. Practically this means we would need to replace the root ``Rectangle`` with an ``Item`` and make the rectangle a nested element in the root item.

    |

    .. code-block:: js

        Item {
            id: root
            width: 116; height: 26

            property alias text: label.text
            signal clicked

            Rectangle {
                anchors.fill parent
                color: "lightsteelblue"
                border.color: "slategrey"
            }
            ...
        }

With this technique, it is easy to create a whole series of reusable components.

Simple Transformations
======================

.. issues:: ch04

.. index:: Transformation, Translation, Rotation, Scaling, ClickableImage Helper, Stacking order

A transformation manipulates the geometry of an object. QML Items can in general be translated, rotated and scaled. There is a simple form of these operations and a more advanced way.

Let's start with the simple transformations. Here is our scene as our starting point.

A simple translation is done via changing the ``x,y`` position. A rotation is done using the ``rotation`` property. The value is provided in degrees (0 .. 360). A scaling is done using the ``scale`` property and a value <1 means the element is scaled down and ``>1`` means the element is scaled up. The rotation and scaling does not change your geometry. The items ``x,y`` and ``width/height`` haven't changed. Just the painting instructions are transformed.

Before we show off the example I would like to introduce a little helper: The ``ClickableImage`` element. The ``ClickableImage`` is just an image with a mouse area. This brings up a useful rule of thumb - if you have copied a chunk of code three times, extract it into a component.

.. literalinclude:: src/transformation/ClickableImage.qml
    :start-after: M1>>
    :end-before: <<M1


.. figure:: assets/objects.png

We use our clickable image to present three objects (box, circle, triangle). Each object performs a simple transformation when clicked. Clicking the background will reset the scene.


.. literalinclude:: src/transformation/TransformationExample.qml
    :start-after: M1>>
    :end-before: <<M1

.. figure:: assets/objects_transformed.png

The circle increments the x-position on each click and the box will rotate on each click. The triangle will rotate and scale the image down on each click, to demonstrate a combined transformation. For the scaling and rotation operation we set ``antialiasing: true`` to enable anti-aliasing, which is switched off (same as the clipping property ``clip``) for performance reasons.  In your own work, when you see some rasterized edges in your graphics, then you should probably switch smooth on.


.. note::

    To achieve better visual quality when scaling images it is recommended to scale images down instead of up. Scaling an image up with a larger scaling factor will result into scaling artifacts (blurred image). When scaling an image you should consider using ``antialiasing : true`` to enable the usage of a higher quality filter.


The background ``MouseArea`` covers the whole background and resets the object values.

.. note::

    Elements which appear earlier in the code have a lower stacking order (called z-order). If you click long enough on ``circle`` you will see it moves below ``box``. The z-order can also be manipulated by the ``z-property`` of an Item.

    .. figure:: assets/objects_overlap.png

    This is because ``box`` appears later in the code. The same applies also to mouse areas. A mouse area later in the code will overlap (and thus grab the mouse events) of a mouse area earlier in the code.

    Please remember: *The order of elements in the document matters*.

Positioning Elements
====================

.. issues:: ch04

.. index:: Row, Column, Grid, Repeater, Flow, Square Helper

There are a number of QML elements used to position items. These are called positioners and the following are provided in the QtQuick module ``Row``, ``Column``, ``Grid`` and ``Flow``. They can be seen showing the same contents in the illustration below.

.. todo: illustration showing row, grid, column and flow side by side showing four images

.. note::

    Before we go into details, let me introduce some helper elements. The red, blue, green, lighter and darker squares. Each of these components contains a 48x48 pixels colorized rectangle. As reference here is the source code for the ``RedSquare``:

    .. literalinclude:: src/positioners/RedSquare.qml
        :start-after: M1>>
        :end-before: <<M1

    Please note the use of ``Qt.lighter(color)`` to produce a lighter border color based on the fill color. We will use these helpers in the next examples to make the source code more compact and hopefully readable. Please remember, each rectangle is initial 48x48 pixels.


The ``Column`` element arranges child items into a column by stacking them on top of each other. The ``spacing`` property can be used to distance each of the child elements from each other.

.. figure:: assets/column.png

.. literalinclude:: src/positioners/ColumnExample.qml
    :start-after: M1>>
    :end-before: <<M1

The ``Row`` element places its child items next to each other, either from the left to the right, or from the right to the left, depending on the ``layoutDirection`` property. Again, ``spacing`` is used to separate child items.

.. figure:: assets/row.png

.. literalinclude:: src/positioners/RowExample.qml
    :start-after: M1>>
    :end-before: <<M1

The ``Grid`` element arranges its children in a grid, by setting the ``rows`` and ``columns`` properties, the number or rows or columns can be constrained. By not setting either of them, the other is calculated from the number of child items. For instance, setting rows to 3 and adding 6 child items will result in 2 columns. The properties ``flow`` and ``layoutDirection`` are used to control the order in which the items are added to the grid, while ``spacing`` controls the amount of space separating the child items.

.. figure:: assets/grid.png

.. literalinclude:: src/positioners/GridExample.qml
    :start-after: M1>>
    :end-before: <<M1

The final positioner is ``Flow``. It adds its child items in a flow. The direction of the flow is controlled using ``flow`` and ``layoutDirection``. It can run sideways or from the top to the bottom. It can also run from left to right or in the opposite direction. As the items are added in the flow, they are wrapped to form new rows or columns as needed. In order for a flow to work, it must have a width or a height. This can be set either directly, or though anchor layouts.

.. figure:: assets/flow.png

.. literalinclude:: src/positioners/FlowExample.qml
    :start-after: M1>>
    :end-before: <<M1

An element often used with positioners is the ``Repeater``. It works like a for-loop and iterates over a model. In the simplest case a model is just a value providing the amount of loops.

.. figure:: assets/repeater.png

.. literalinclude:: src/positioners/RepeaterExample.qml
    :start-after: M1>>
    :end-before: <<M1

In this repeater example, we use some new magic. We define our own color property, which we use as an array of colors. The repeater creates a series of rectangles (16, as defined by the model). For each loop he creates the rectangle as defined by the child of the repeater. In the rectangle we chose the color by using JS math functions ``Math.floor(Math.random()*3)``. This gives us a random number in the range from 0..2, which we use to select the color from our color array. As noted earlier, JavaScript is a core part of Qt Quick, as such the standard libraries are available for us.

A repeater injects the ``index`` property into the repeater. It contains the current loop-index. (0,1,..15). We can use this to make our own decisions based on the index, or in our case to visualize the current index with the ``Text`` element.

.. note::

    More advanced handling of larger models and kinetic views with dynamic delegates is covered in an own model-view chapter. Repeaters are best used when having a small amount of static data to be presented.

Layout Items
============

.. issues:: ch04

.. index:: anchors

.. todo:: do we need to remove all uses of anchors earlier?

QML provides a flexible way to layout items using anchors. The concept of anchoring is part of the ``Item`` fundamental properties and available to all visual QML elements. An anchors acts like a contract and is stronger than competing geometry changes. Anchors are expressions of relativeness, you always need a related element to anchor with.

.. figure:: assets/anchors.png

An element has 6 major anchor lines (top, bottom, left, right, horizontalCenter, verticalCenter). Additional there is the baseline anchor for text in Text elements. Each anchor line comes with an offset. In the case of top, bottom, left and right they are called margins. For horizontalCenter, verticalCenter and baseline they are called offsets.

.. figure:: assets/anchorgrid.png

#. An element fills a parent element

    .. literalinclude:: src/anchors/AnchorsExample.qml
        :start-after: M1>>
        :end-before: <<M1


#. An element is left aligned to the parent

    .. literalinclude:: src/anchors/AnchorsExample.qml
        :start-after: M2>>
        :end-before: <<M2

#. An element left side is aligned to the parents right side

    .. literalinclude:: src/anchors/AnchorsExample.qml
        :start-after: M3>>
        :end-before: <<M3

#. Center aligned elements. ``Blue1`` is horizontal centered  on the parent. ``Blue2`` is also horizontal centered but on ``Blue1`` and it's top is aligned to the ``Blue1`` bottom line.

    .. literalinclude:: src/anchors/AnchorsExample.qml
        :start-after: M4>>
        :end-before: <<M4


#. An element is centered on a parent element

    .. literalinclude:: src/anchors/AnchorsExample.qml
        :start-after: M5>>
        :end-before: <<M5


#. An element is centered with an left-offset on a parent element using horizontal and vertical center lines

    .. literalinclude:: src/anchors/AnchorsExample.qml
        :start-after: M6>>
        :end-before: <<M6

.. note:: Our squares have been enhanced to enable dragging. Try the example and drag around some squares. You will see that (1) can't be dragged as it's anchored on all sides, sure you can drag the parent of (1) as it's not anchored at all. (2) can be vertically dragged as only the left side is anchored. Similar applies to (3). (4) can only be dragged vertically as both squares are horizontal centered. (5) is centered on the parent and as such can't be dragged, similar applies to (7). Dragging an element means changing their ``x,y`` position. As anchoring is stronger than geometry changes such as ``x,y``, dragging is restricted by the anchored lines. We will see this effect later when we discuss animations.

Input Elements
==============

.. issues:: ch04

.. index:: TextInput, TextEdit, FocusScope, focus, Keys, KeyNavigation

We have already used the ``MouseArea`` as a mouse input element. Next, we'll  focus on keyboard input. We start off with the text editing elements: ``TextInput`` and ``TextEdit``.

TextInput
---------

.. issues:: ch04


The ``TextInput`` allows the user to enter a line of text. The element supports input constraints such as ``validator``, ``inputMask``, and ``echoMode``.

.. literalinclude:: src/input/TextInputExample.qml
    :start-after: M1>>
    :end-before: <<M1

.. figure:: assets/textinput.png

The user can click inside a ``TextInput`` to change the focus. To support switching the focus by keyboard, we can use the ``KeyNavigation`` attached property.

.. literalinclude:: src/input/TextInputExample2.qml
    :start-after: M1>>
    :end-before: <<M1

The ``KeyNavigation`` attached property supports a preset of navigation keys where an element id is bound to switch focus on the given key press.

A text input element comes with no visual presentation besides a blinking cursor and the entered text. For the user to be able to recognize the element as an input element it needs some visual decoration, for example a simple rectangle. When placing the ``TextInput`` inside an element you need make sure you export the major properties you want others be able to access.

We move this piece of code into our own component called ``TLineEditV1`` for reuse.

.. literalinclude:: src/input/TLineEditV1.qml
    :start-after: M1>>
    :end-before: <<M1

.. note::

    If you want to export the ``TextInput`` completely, you can export the element by using ``property alias input: input``. The first ``input`` is the property name, where the 2nd input is the element id.


We rewrite our ``KeyNavigation`` example with the new ``TLineEditV1`` component.

.. code-block:: js

    Rectangle {
        ...
        TLineEditV1 {
            id: input1
            ...
        }
        TLineEditV1 {
            id: input2
            ...
        }
    }

.. figure:: assets/textinput3.png

And try the tab key for navigation. You will experience the focus does not change to ``input2``. The simple use of ``focus:true`` is not sufficient. The problem arises, that the focus was transferred to the ``input2`` element the top-level item inside the TlineEditV1 (our Rectangle) received focus and did not forward the focus to the TextInput. To prevent this QML offers the FocusScope.

FocusScope
----------

.. issues:: ch04

A focus scope declares that the last child element with ``focus:true`` receives the focus if the focus scope receives the focus. So it's forward the focus to the last focus requesting child element. We will create a 2nd version of our TLineEdit component called TLineEditV2 using the focus scope as root element.

.. literalinclude:: src/input/TLineEditV2.qml
    :start-after: M1>>
    :end-before: <<M1

Our example will now look like this:

.. code-block:: js

    Rectangle {
        ...
        TLineEditV2 {
            id: input1
            ...
        }
        TLineEditV2 {
            id: input2
            ...
        }
    }

Pressing the tab key now successfully switches the focus between the 2 components and the correct child element inside the component is focused.


TextEdit
--------

.. issues:: ch04

The ``TextEdit`` is very similar to ``TextInput`` and support a multi-line text edit field. It doesn't have the text constraint properties as this depends on querying the painted size of the text (``paintedHeight``, ``paintedWidth``). We also create our own component called ``TTextEdit`` to provide a edit background and use the focus scope for better focus forwarding.

.. literalinclude:: src/input/TTextEdit.qml
    :start-after: M1>>
    :end-before: <<M1

You can use it like the ``TLineEdit`` component

.. literalinclude:: src/input/TextEditExample.qml
    :start-after: M1>>
    :end-before: <<M1

.. figure:: assets/textedit.png

Keys Element
------------

.. issues:: ch04

The attached property ``Keys`` allows executing code based on certain key presses. For example to move a square around and scale we can hook into the up, down, left and right keys to translate the element and the plus, minus key to scale the element.

.. literalinclude:: src/input/KeysExample.qml
    :start-after: M1>>
    :end-before: <<M1

.. figure:: assets/keys.png


Advanced Techniques
===================

.. issues:: ch04

.. todo:: To be written







