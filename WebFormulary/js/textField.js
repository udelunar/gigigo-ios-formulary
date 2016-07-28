
//======================================
//               TEXT                 //
//======================================
            
function createField(keyTextField,title,placeHolder,error,mandatory,cellColor,keyboard,validator,minLength,maxLength,titleColor,errorColor,sizeTitle,sizeError,align,font) {    
    var valueCheck = ""
    if (mandatory) {
        valueCheck = "checked"
    }

    //-- Recover Styles --
    var htmlBackgroundColor = getStyleColor(cellColor,titleColor,errorColor);
    var htmlFontSize = getStyleSize (sizeTitle, sizeError);
    var styles =  htmlFontSize + htmlBackgroundColor;

    var html = '<div class="cellConstructor"id="fieldNumber'+indexField+'"><div class="row"><div class="col-md-10"><div class="keyTextField"><p>key*:</p><input type="text"name="keyTextField"id="keyTextField"disabled value="'+keyTextField+'"></div><div class="containerTextFieldTop"><div class="titleTextField"><p>Titulo*:</p><input type="text"name="titleTextField"id="titleTextField"disabled value="'+title+'"></div><div class="keyboardResult">Keyboard:'+keyboard+'</div></div><div class="containerTextFieldCenter"><div class="inputTextField"><p>PlaceHolder:</p><input type="text"name="palceHolderTextField"id="palceHolderTextField"disabled value="'+placeHolder+'"></div><div class="mandatoryTextField"><input type="checkbox"name="mandatory"value="mandatory"id="mandatory"'+valueCheck+'disabled readonly><p>Es obligatorio?</p></div><div class="validatorResult">Validator:'+validator+'</div></div><div class="errorTextField"><p class="textErrorP">Texto error:</p><input type="text"name="errorTextField"id="errorTextField"disabled value="'+error+'"><p>minLength:</p><input class="inputWidth"type="text"name="minLength"id="minLength"disabled readonly value="'+minLength+'"><p>maxLength:</p><input class="inputWidth"type="text"name="maxLength"id="maxLength"disabled readonly value="'+maxLength+'"></div><div class="styleField"><h4>Estilos de celda:</h4>'+styles+'</div><div class="spaceSeparate"></div></div><div class="col-md-2 buttonRemove buttonRemoveText"onclick="removeField('+indexField+')"><p>-</p></div></div></div>';

    $("#containerListItemsCreated").append(html);
    resetTypeField();
}

function saveField(keyTextField,type,title,placeHolder,error,mandatory,cellColor,keyboard,validator,minLength,maxLength,titleColor,errorColor,sizeTitle,sizeError,align,font) {
    //-- Mandatory Fiedls --
    var itemSave = {
        "tag":indexField,
        "key":keyTextField,
        "type":type,
        "label":title,
        "textError":error,
        "mandatory":mandatory,
    }
    
    if (placeHolder.length > 0) {
        itemSave["placeHolder"] = placeHolder
    }                
    if (minLength.length > 0) {
        itemSave["minLength"] = parseInt(minLength)
    }                
    if (maxLength.length > 0) {
        itemSave["maxLength"] = parseInt(maxLength)
    }                
    if (keyboard != "None") {
        itemSave["keyboard"] = keyboard
    }                
    if (validator != "None") {
        itemSave["validator"] = validator
    }
    
    //-- OPTIONAL FIELDS --
    var styles = getStylesJson(cellColor,titleColor,errorColor,sizeTitle,sizeError,"","","",align,font);

    if (styles != null) {
        itemSave["style"] = styles
    } 
    
    listFieldsResult.push(itemSave)
    
    /*
    for (var i=0; i<listFieldsResult.length; i++) {
        $.each(listFieldsResult[i], function(index, val) {
            console.log("key:"+index+" - value:"+val);
        });
    }*/
    
    indexField++;
}
