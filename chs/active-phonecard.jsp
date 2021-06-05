<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.*"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  HttpSession session = request.getSession(false);
  String randCode = null;
  if (session != null) {
    randCode = (String) session.getAttribute("randCode");
    session.removeAttribute("randCode");
  }
  String code = request.getParameter("randomCode");
  WebActivePhoneCardResponse responseVos = new WebActivePhoneCardResponse();
  if (randCode == null || !randCode.equals(code)) {
    responseVos.retCode = RetCodeValue.W_ERROR_VERIFYCODE;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  WebActivePhoneCard requestVos = (WebActivePhoneCard) JsonUtil.fromJson(request.getReader(), WebActivePhoneCard.class);
  if (requestVos.pin == null || requestVos.pin.trim().isEmpty()) {
    responseVos.retCode = RetCodeValue.W_ERROR_MISSPARAMETER;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  requestVos.pin = requestVos.pin.trim();
  requestVos.fromIp = request.getRemoteAddr();
  requestVos.loginName = requestVos.pin;
  responseVos = (WebActivePhoneCardResponse) MGCConfig.listenerEquipment().sendRequestSyn(
      WebBodyId.VOS_WEB_ACTIVEPHONECARD_REQ, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (responseVos == null) {
    responseVos = new WebActivePhoneCardResponse();
    responseVos.retCode = RetCodeValue.F_ERROR_TIMEOUT;
  }
  responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
  response.getWriter().write(JsonUtil.toJson(responseVos));
  out.clear();
%>
