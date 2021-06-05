<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.*"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.common.CommonAlgorithm"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%@page import="com.kunshi.vos.clientweb.Util"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.Vector"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  WebInfoTerminalLogin sessionInfo = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  ResponseCommon responseVos = new ResponseCommon();
  if (sessionInfo == null) {
    responseVos.retCode = RetCodeValue.W_ERROR_FAILED;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  SetWebPhonebook requestVos = (SetWebPhonebook) JsonUtil.fromJson(request.getReader(), SetWebPhonebook.class);
  if (requestVos == null) {
    responseVos.retCode = RetCodeValue.W_ERROR_MISSPARAMETER;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  requestVos.phoneBookType = sessionInfo.terminalType == 0 ? 54:26;
  Util.copyLoginInfo(request, sessionInfo, requestVos);
  responseVos = (ResponseCommon) MGCConfig.listenerEquipment().sendRequestSyn(
      WebBodyId.VOS_WEB_SETINFOPHONEBOOK_REQ, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (responseVos == null) {
    responseVos = new ResponseCommon();
    responseVos.retCode = RetCodeValue.F_ERROR_TIMEOUT;
  }
  responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
  response.getWriter().write(JsonUtil.toJson(responseVos));
  out.clear();
%>
