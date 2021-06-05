<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.ReqSetInfo"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.common.RspSetInfo"%>
<%@page import="com.kunshi.platform.common.Trace"%>
<%@page import="com.kunshi.platform.common.CommonAlgorithm"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.IListener"%>
<%@page import="com.kunshi.platform.mgc.common.MGCMessage"%>
<%@page import="com.kunshi.interfaceo.vos.external.server.*"%>
<%@page import="com.kunshi.interfaceo.vos.ExternalBodyId"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  try {
    GetCdr requestVos = (GetCdr)JsonUtil.fromJson(request.getReader(), GetCdr.class);
    if (requestVos == null) {
      return;
    }
    GetCdrResponse responseVos = new GetCdrResponse();
    responseVos = (GetCdrResponse) MGCConfig.listenerWebServer().sendRequestSyn(
        ExternalBodyId.GET_CDR, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
    if (responseVos == null) {
      responseVos = new GetCdrResponse();
      responseVos.retCode = RetCodeValue.F_ERROR_TIMEOUT;
    }
    responseVos.exception = ShowErrorMessage.exceptionValue(responseVos.retCode);    
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
  }
  catch (Exception e1) {
    Trace.println(e1);
  }
%>
