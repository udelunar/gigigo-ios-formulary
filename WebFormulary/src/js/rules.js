
window.getRules= function getRules() {  
	return '<div class="zoneRule"><input type="checkbox"name="rules"value="rules"id="rules"><p id="textActiteRule">Active rule?</p><div id="containerRule"><div id="fieldCompareRules"><p>Keys Compare:</p><input type="text"name="fieldReciver"id="fieldReciver"placeholder="key1,key2"></div><div id="compareRule"><p>Comparate:</p><select class="selectTypeRuleCompare"><option value="none">Elegir tipo de comparacion</option><option value="<">Menor que</option><option value=">">Mayor que</option><option value="=">igual</option><option value="!=">distinto</option></select></div><div id="valueRuleContainer"><p>Valor a comparar:</p><input type="text"name="valueRule"id="valueRule"></div><div id="behaviorRule"><p>Comportamiento si cumple la regla:</p><select class="selectTypeRuleBehavior"><option value="">Elegir tipo de comportamiento</option><option value="show">Mostrar</option><option value="hide">Ocultar</option><option value="enable">Activo</option><option value="disable">Desactivo</option></select></div><div id="elseBehaviorRule"><p>Comportamiento si NO cumple la regla:</p><select class="selectTypeRuleElseBehavior"><option value="">Elegir tipo de comportamiento</option><option value="show">Mostrar</option><option value="hide">Ocultar</option><option value="enable">Activo</option><option value="disable">Desactivo</option></select></div></div></div>';
}