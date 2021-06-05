<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.common.RspGetInfo"%>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoPhonecard"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
  HttpSession session = request.getSession(false);
  String randCode = null;
  if (session != null) {
    randCode = (String) session.getAttribute("randCode");
    session.removeAttribute("randCode");
  }
  String code = request.getParameter("randCode");
  if (randCode == null || !randCode.equals(code)) {
    response.getWriter().write(RetCodeValue.W_ERROR_VERIFYCODE + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_VERIFYCODE));
    return;
  }
  WebInfoPhonecard info = new WebInfoPhonecard();
  info.pin = request.getParameter("pin");
  info.password = request.getParameter("password");
  RspGetInfo rsp = (RspGetInfo) MGCConfig.listenerWebServer().sendRequestSyn(WebBodyId.VOS_WEB_CHECKPHONECARD_REQ, info, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (rsp == null) {
    response.getWriter().write(RetCodeValue.W_ERROR_TIMEOUT + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_TIMEOUT));
    return;
  }
  if (rsp.retCode != RetCodeValue.F_OK) {
    response.getWriter().write(rsp.retCode + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), rsp.retCode));
    return;
  }
  info = (WebInfoPhonecard) rsp.retInfo;
  response.getWriter().write(RetCodeValue.F_OK + "|");
  response.getWriter().write(info.money + "|");
  response.getWriter().write(new SimpleDateFormat("yyyy/MM/dd").format(new Timestamp(info.expireTime)) + "|");
  response.getWriter().write(info.activeDay + "|");
%>
