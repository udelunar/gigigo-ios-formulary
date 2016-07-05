        var fieldSelected = ""
            var listFieldsResult = []
            var indexField = 0
            
            
            function saveField(type,title,placeHolder,error,mandatory,cellColor,keyboard,validator) {
                var style = {}
                var haveStyle = false;
                
                if (cellColor.length > 0) {
                    style["backgroundColorField"] = cellColor
                    haveStyle = true;
                }
                
                var itemSave = {
                    "tag":indexField,
                    "type":type,
                    "label":title,
                    "error":error,
                    "mandatory":mandatory,
                }
                
                if (placeHolder.length > 0) {
                    itemSave["placeHolder"] = placeHolder
                }
                
                if (keyboard != "None") {
                    itemSave["keyboard"] = keyboard
                }
                
                if (validator != "None") {
                    itemSave["validator"] = validator
                }
                
                if (haveStyle) {
                    itemSave["style"] = style
                }
                
                //	alert(itemSave);
                
                listFieldsResult.push(itemSave)
                
                for (var i=0; i<listFieldsResult.length; i++) {
                    $.each(listFieldsResult[i], function(index, val) {
                        console.log("key:"+index+" - value:"+val);
                    });
                }
                
                indexField++;
            }
        
            function removeField(idRemove){
                var auxListFieldsResult = [];
                
                for (var i=0; i<listFieldsResult.length; i++) {
                    
                    var find = false;
                    
                    $.each(listFieldsResult[i], function(index, val) {
                        if (index == "tag" && val == idRemove){
                            find = true;
                        }
                    });
                    
                    if (!find) {
                        auxListFieldsResult.push(listFieldsResult[i])
                    }
                }
                
                listFieldsResult = auxListFieldsResult;
                
                $("#fieldNumber"+idRemove).slideUp();
            }
            
            
            function createField(title,placeHolder,error,mandatory,cellColor,keyboard,validator) {
                
                var valueCheck = ""
                if (mandatory) {
                    valueCheck = "checked"
                }
                var htmlBackgroundColor = '<div class="colorZone"><p>Color de la celda:</p><div id="cellColor"></div></div>';
                if (cellColor != "") {
                    htmlBackgroundColor = '<div class="colorZone"><p>Color de la celda:</p><div id="cellColor" style="background-color:'+cellColor+'">'+cellColor+'</div></div>'
                }

                var html = '<div class="cellConstructor" id="fieldNumber'+indexField+'"><div class="row"><div class="col-md-8"><div class="containterTop"><p class="titleTextFieldResult">'+title+'</p>'+htmlBackgroundColor+'</div><div class="containterMid"><p class="placeHolderTextFieldResult">'+placeHolder+'</p><input class="mandatoryTextFieldResult" type="checkbox" name="mandatory" value="mandatory" '+valueCheck+' disabled readonly></div><p class="errorTextFieldResult">'+error+'</p></div><div class="col-md-2 buttonRemove" onclick="removeField('+indexField+')"><p>-</p></div></div></div>';
                $("#containerListItemsCreated").append(html);
                resetTypeField();
            }
        
            function validateTextField() {
                var title = $("#titleTextField").val()
                var placeHolder = $("#palceHolderTextField").val()
                var error = $("#errorTextField").val()
                var mandatory = $('#mandatory').is(':checked');
                var cellColor = $("#cellColor").text()
                var keyboard = document.getElementById("selectTypeKeyboard").value;
                var validator = document.getElementById("selectTypeValidator").value;
                
                if (error.length == 0) {
                    error = "error_generic_field"
                }
                
                if (title.length > 0) {
                    createField(title,placeHolder,error,mandatory,cellColor,keyboard,validator);
                    saveField("text",title,placeHolder,error,mandatory,cellColor,keyboard,validator)
                }
                else {
                    alert("Los campos con asterisco son obligatorios");
                }
            }
            
            function addField() {
                if (fieldSelected == "Text") {
                    validateTextField();
                }
                else if (typeField == "Picker") {
                    alert("Picker");
                }
            }
        
            function resetTypeField() {
                clearTypeField()
                $(".selectTypeField").val("None");
            }
        
            function clearTypeField(){
                $("#createField").slideUp(function(){
                       $("#containterElementField").empty()
                });
            }
        
            //======================================
            //          ADD NEW FILED             //
            //======================================
        
            function createElementField(typeField) {
                
                fieldSelected = typeField;
                
                if (typeField == "Text") {
                    
                    var html = '<div class="cellConstructor" id="createField">                       <div class="row">                           <div class="col-md-10"><div class="containerTextFieldTop">                                   <div class="titleTextField">                                       <p>Titulo*:</p>                                       <input type="text" name="titleTextField" id="titleTextField">                                           </div>                                   <div class="colorZone">                                       <p>Color de la celda:</p>                                       <div id="cellColor"  onclick="cellColorOpen()"></div>                                   </div>                                    <select id="selectTypeKeyboard">                                        <option value="None">Elegir tipo de teclado</option>                                        <option value="FormKeyboardTypeText">Texto</option>                                        <option value="FormKeyboardTypeEmail">Email</option>                                        <option value="FormKeyboardTypeNumbers">Nuerico</option>                                        <option value="FormKeyboardTypeNumberPad">NuericoPad</option>                                    </select>                               </div><div class="containerTextFieldCenter">                                   <div class="inputTextField">                                      <p>PlaceHolder:</p>                                       <input type="text" name="palceHolderTextField" id="palceHolderTextField">                                   </div>                                   <div class="mandatoryTextField">                                       <input type="checkbox" name="mandatory" value="mandatory" id="mandatory">                                           <p>Es obligatorio?</p></div><select id="selectTypeValidator"><option value="None">Tipo validador</option>                                        <option value="text">Texto</option>                                        <option value="email">Email</option>                                       <option value="numeric">Numérico</option></select>                                 </div>                               <div class="errorTextField">                                   <p>Texto error*:</p>                                   <input type="text" name="errorTextField"id="errorTextField">                                       </div>                           </div>                           <div class="col-md-2 buttonAdd" onclick="addField()">                               <p>+</p>                           </div>                       </div>                   </div> ';
                    $("#containterElementField").append(html)
                }
                else if (typeField == "Picker") {
                    
                }
            }
        
            function syntaxHighlight(json) {
            if (typeof json != 'string') {
                json = JSON.stringify(json, undefined, 2);
            }
            json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
                                var cls = 'number';
                                if (/^"/.test(match)) {
                                    if (/:$/.test(match)) {
                                    cls = 'key';
                                    } else {
                                    cls = 'string';
                                    }
                                    } else if (/true|false/.test(match)) {
                                    cls = 'boolean';
                                    } else if (/null/.test(match)) {
                                    cls = 'null';
                                    }
                                    return '<span class="' + cls + '">' + match + '</span>';
                                    });
             }
                                
                                
                                
              function copiarAlPortapapeles() {
                    var aux = document.createElement("input");
                                
                    var recoverJSON = JSON.stringify(listFieldsResult, undefined, 4);
                    recoverJSON = '{ \n "fields":'+recoverJSON+' \n}';
                                
                    aux.setAttribute("value", recoverJSON);
                    document.body.appendChild(aux);
                    aux.select();
                    document.execCommand("copy");
                    document.body.removeChild(aux);
                }
                                
            function output(inp) {
                 document.body.appendChild(document.createElement('pre')).innerHTML = inp;
            }
                                
                                
        
            $(".selectTypeField").change(function() {
                 createElementField(this.value)
            });
            
            $("#buttonGenerateJson").click(function() {
                $("#containerJsonItemsCreated").empty()
                var recoverJSON = JSON.stringify(listFieldsResult, undefined, 4);
                recoverJSON = '{ \n "fields":'+recoverJSON+' \n}';
               $("#containerJsonItemsCreated").append("<button class='btn butonCopyPaste' data-clipboard-action='copy' data-clipboard-target='#bar'>Copiar</button><textarea id='bar'>"+recoverJSON+"</textarea><pre>"+syntaxHighlight(recoverJSON)+"</pre>")
            });
                       
            function cellColorOpen() {
                $("#ControlColor").show();
            }
                                
            $("#closeSaveColor").click(function() {
                $("#ControlColor").hide();
                $("#cellColor").css("background-color", $("#testPatch").text());
                $("#cellColor").empty()
                $("#cellColor").append("<p id='colorId'>"+$("#testPatch").text()+"</p>");
            });
                                
                                var clipboard = new Clipboard('.btn');
                                
                                clipboard.on('success', function(e) {
                                             console.log("OK");
                                             console.log(e);
                                             });
                                
                                clipboard.on('error', function(e) {
                                             console.log("OK");
                                             console.log(e);
                                             });