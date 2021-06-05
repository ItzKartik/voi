<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.common.CommonAlgorithm"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  GetWebFeeRateResponse webResponse = new GetWebFeeRateResponse();
  HttpSession session = request.getSession(false);
  WebInfoTerminalLogin info = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (null == info) {
    webResponse.retCode = RetCodeValue.W_ERROR_FAILED;
    webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  FilterWebInfoFeeRate filter = new FilterWebInfoFeeRate();
  filter.mask = CommonAlgorithm.stringToInt(request.getParameter("mask"));
  if (filter.mask == FilterWebInfoFeeRate.PHONE_FEERATE) {
    filter.e164 = info.terminalName;
  }
  else {
    filter.account = info.customerAccount;
  }
  filter.info.mask = 0;
  if (request.getParameter("prefix") != null && request.getParameter("prefix").trim().length() > 0) {
    filter.info.feePrefix = request.getParameter("prefix");
    filter.info.mask |= WebInfoOneFeeRate.MASK_PREFIX;
  }
  if (request.getParameter("areaCode") != null && request.getParameter("areaCode").trim().length() > 0) {
    filter.info.areaCode = request.getParameter("areaCode");
    filter.info.mask |= WebInfoOneFeeRate.MASK_AREACODE;
  }
  if (request.getParameter("feerategroup_id") != null) {
    filter.info.id = CommonAlgorithm.stringToInt(request.getParameter("feerategroup_id"), -1);
  }
  int start = CommonAlgorithm.stringToInt(request.getParameter("start"));
  if (start == 0) {
    session.removeAttribute("TotalCount");
  }
  int l = CommonAlgorithm.stringToInt(request.getParameter("limit"));
  filter.pageIndex = (start + l) / l;
  webResponse = (GetWebFeeRateResponse) MGCConfig.listenerWebServer().sendRequestSyn(WebBodyId.VOS_WEB_GETWEBINFOFEERATE_REQ, filter, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (webResponse == null) {
    webResponse = new GetWebFeeRateResponse();
    webResponse.retCode = RetCodeValue.F_ERROR_TIMEOUT;
    webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  if (webResponse.retCode == RetCodeValue.F_OK) {
    if (start > 0) {
      webResponse.total = (Integer) session.getAttribute("TotalCount");
    }
    else {
      session.setAttribute("TotalCount", webResponse.total);
    }
  }
  webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
  response.getWriter().write(JsonUtil.toJson(webResponse));
  out.clear();
%>
