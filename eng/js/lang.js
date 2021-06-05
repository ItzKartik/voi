function loadLanguage()
{
    var url = window.location.href;
    if(url.indexOf("eng") >= 0)
    {
        if(url.indexOf("/phonebook") >= 0 || url.indexOf("/ipcentrex") >= 0)
        {
            document.write('<script type="text/javascript" src="../js/lang_en_us.js"></script>');
            return;
        }
        document.write('<script type="text/javascript" src="js/lang_en_us.js"></script>');
        if(url.indexOf("main") >= 0)
        {
            document.write("<style type='text/css'>.x-layout-collapsed-west {background-image:url(images/west_en_us.gif);}</style>");
        }
        if(url.indexOf("query") >= 0)
        {
            document.write("<style type='text/css'>.x-layout-collapsed-west {background-image:url(images/west_en_us_2.gif);}</style>");
        }
    }
    else if(url.indexOf("cht") >= 0)
    {
        if(url.indexOf("/phonebook") >= 0 || url.indexOf("/ipcentrex") >= 0)
        {
            document.write('<script type="text/javascript" src="../js/lang_zh_tw.js"></script>');
            return;
        }
        document.write('<script type="text/javascript" src="js/lang_zh_tw.js"></script>');
        if(url.indexOf("main") >= 0)
        {
            document.write("<style type='text/css'>.x-layout-collapsed-west {background-image:url(images/west_zh_tw.gif);}</style>");
        }
        if(url.indexOf("query") >= 0)
        {
            document.write("<style type='text/css'>.x-layout-collapsed-west {background-image:url(images/west_zh_tw_2.gif);}</style>");
        }
    }
    else
    {
        if(url.indexOf("/phonebook") >= 0 || url.indexOf("/ipcentrex") >= 0)
        {
            document.write('<script type="text/javascript" src="../js/lang_zh_cn.js"></script>');
            return;
        }
        document.write('<script type="text/javascript" src="js/lang_zh_cn.js"></script>');
        if(url.indexOf("main") >= 0)
        {
            document.write("<style type='text/css'>.x-layout-collapsed-west {background-image:url(images/west_zh_cn.gif);}</style>");
        }
        if(url.indexOf("query") >= 0)
        {
            document.write("<style type='text/css'>.x-layout-collapsed-west {background-image:url(images/west_zh_cn_2.gif);}</style>");
        }
    }
}
loadLanguage();