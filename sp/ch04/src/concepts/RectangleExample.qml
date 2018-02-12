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

// M1>>
//Rectangle.qml
import QtQuick 2.10
import QtQuick.Window 2.3

//Solo para mostrarlo como ejecutable
Window{
    width: 120; height: 240

    visible: true

    //El elemento visible base es un Rectangle
    Rectangle{
        //Nombre este elemento como base
        id: base
        //propiedades: <nombre>: <valor>
        width: 120; height: 240

        //Propiedad de Color
        color: "#4A4A4A"

        //Declaracion de un elemento hijo (hijo de base)
        Image{
            id: triangulo

            //Referencia directa al padre
            x: (parent.width-width)/2; y: 40

            source: 'assets/triangle_red.png'
        }

        //Otro hijo de base
        Text{
            //Elemento sin nombre

            //Referencia de elemento por id
            y: triangulo.y + triangulo.height+20

            //Referencia elemento base
            width: base.width

            color: 'white'
            horizontalAlignment: Text.AlignHCenter
            text: 'Triangulo'
        }
    }
}
// <<M1
