/*
 * Copyright (c) 2013, Juergen Bocklage-Ryannel, Johan Thelin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the editors nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

//properties.qml
import QtQuick 2.10
import QtQuick.Window 2.3

Window{
    visible: true
    Rectangle{
        width: 240; height: 120

        //M1>>
        Text{
            //(1) Identificador
            id:thisLabel
            //(2) Indicar posicion en x y y
            x: 24; y: 16
            //(3) Enlazar altura con 2 veces ancho
            height: 2*width
            //(4) Propiedad personalizada
            property int times:24
            //(5) Alias de Propiedad
            property alias anotherTimes: thisLabel.times
            //(6) Texto enlazado a otro valor
            text: "Greetings "+ times
            //(7) Font es una propiedad agrupada
            font.family: "Ubuntu"
            font.pixelSize: 24
            //(8) KeyNavigation es una propiedad "incluida"
            KeyNavigation.tab: otherLabel
            //(9) Manipulador de senal para cambios en propiedades
            onHeightChanged: console.log('height:',height)
            // Focus es necesario para recibir eventos del teclado
            focus: true
            //Cambiar color basado en el valor de focus
            color: focus?"red":"black"
        }
        // <<M1

        Text{
            //(1) Identificador
            id:otherLabel
            x:24;y:64
            text: "Other Label"
            //(6) Texto enlazado a otro valor
            font.family: "Ubuntu"
            font.pixelSize: 24
            // (7) Keys is a attached property
            KeyNavigation.tab: thisLabel
            color: focus?"red":"black"
        }
    }
}
