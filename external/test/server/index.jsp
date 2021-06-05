<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<html>
<head>
<title>VOS面向服务器接口测试</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="expires" content="-1"/>
</head>
<%!
  public Vector<String> files(String path) {
    Vector<String> values = new Vector<String>();
    try
    {
      File parentF = new File(path);
      for (String file : parentF.list()) {
        if(file.endsWith(".html"))
        {
          values.add(file);
        }
        Collections.sort(values);
      }
    }
    catch(Exception e)
    {
    }
    return values;
  }
%>
<body>
<table>
  <TR>
    <TD>VOS面向服务器接口测试</TD>
  </TR>
</table>
<table bgcolor="#d6f7ff" width="100%">
  <%
              StringBuffer tableLine = new StringBuffer();
              for (String file : files(request.getRealPath("/test/server"))) {
                tableLine.append("<tr>").append("<td>");
                tableLine.append("<a href=\"").append(file).append("\">").append(file.substring(0, file.length()-5)).append("</a>");
                tableLine.append("</td>").append("</tr>");
              }
              out.write(tableLine.toString());
            %>
</table>
</body>
</html>
