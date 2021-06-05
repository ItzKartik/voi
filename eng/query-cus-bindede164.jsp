<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  GetWebBindedE164Response webResponse = new GetWebBindedE164Response();
  WebInfoTerminalLogin info = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (null == info) {
    webResponse.retCode = RetCodeValue.W_ERROR_FAILED;
    webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  if (info.terminalType == VosWebTypes.LoginType.BINDEDE164) {
    webResponse.total = 1;
    WebInfoBindedE164 infoBindedE164 = new WebInfoBindedE164();
    infoBindedE164.e164 = info.terminalName;
    infoBindedE164.id = info.terminalId;
    webResponse.infos.add(infoBindedE164);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  if (info.terminalType != VosWebTypes.LoginType.PHONECARD) {
    webResponse.retCode = RetCodeValue.W_ERROR_QUERY_WRONG;
    webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  FilterWebBindedE164 filter = new FilterWebBindedE164();
  filter.info.activePhoneCardId = info.terminalId;
  filter.mask = 0;
  if (request.getParameter("e164") != null && request.getParameter("e164").trim().length() > 0) {
    filter.info.e164 = request.getParameter("e164");
    filter.mask |= FilterWebBindedE164.MASK_E164;
  }
  if (request.getParameter("memo") != null && request.getParameter("memo").trim().length() > 0) {
    filter.info.memo = request.getParameter("memo");
    filter.mask |= FilterWebBindedE164.MASK_MEMO;
  }
  webResponse = (GetWebBindedE164Response) MGCConfig.listenerEquipment().sendRequestSyn(WebBodyId.VOS_WEB_GETINFOBINDEDE164_REQ, filter, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (webResponse == null) {
    webResponse = new GetWebBindedE164Response();
    webResponse.retCode = RetCodeValue.F_ERROR_TIMEOUT;
    webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
  response.getWriter().write(JsonUtil.toJson(webResponse));
  out.clear();
%>
