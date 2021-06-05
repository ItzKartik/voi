function renderTime(val){
	var s = new String(val);
	return s.substr(0, 19);
}
function renderHourTime(val){
	var retValue = new String();
	var intValue = parseInt(val / 3600);
	if(intValue >= 10)
	{
		retValue = intValue;
	}
	else if(intValue > 0)
	{
		retValue = "0" + intValue;
	}
	else
	{
		retValue = "00";
	}
	retValue += ":";
	intValue = parseInt(val % 3600 / 60);
	if(intValue >= 10)
	{
		retValue += intValue;
	}
	else if(intValue > 0)
	{
		retValue += "0" + intValue;
	}
	else
	{
		retValue += "00";
	}
	retValue += ":";
	intValue = parseInt(val % 60);
	if(intValue >= 10)
	{
		retValue += intValue;
	}
	else if(intValue > 0)
	{
		retValue += "0" + intValue;
	}
	else
	{
		retValue += "00";
	}
	return retValue;
}


function renderType(val){
	switch (val)
	{
	case 1:
		return s[71];
		break;
	case 2:
		return s[72];
		break;
	case 4:
		return s[74];
		break;
	case 5:
		return s[75];
		break;
	default:
		return "";
	}
}

function renderCalleeBilling(val){
	return val == '0' ? s[220] : s[221];
}

function rendererDeviceType(value)
{
	var v = "" + value;
	switch (v)
	{
	case "1":
		return s[233];
		break;
	case "2":
		return s[234];
		break;
	case "3":
		return s[235];
		break;
	default:
		return "";
	}
}
function renderAddressType(value)
{
	var v = "" + value;
	switch (v)
	{
	case "1":
		return s[237];
		break;
	case "2":
		return s[238];
		break;
	default:
		return "";
	}
}

function getDayTimeBegin(date,interval)
{
	var retValue = new Date(date);
	retValue.clearTime();
	if(interval == null)
	{
		interval = 0;
	}
	retValue.setDate(date.getDate()+ interval);
	return retValue;
}
function dateAdd(date, type, interval)
{
	var retValue = new Date(date);
	switch(type.toLowerCase()){
	case "h":
		retValue.setHours(date.getHours()+interval);
		return retValue;
	}
	return retValue;
}
