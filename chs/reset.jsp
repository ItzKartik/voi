<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%
  HttpSession session = request.getSession(false);
  if (session != null) {
    session.removeAttribute("Info");
    session.invalidate();
  }
%>
