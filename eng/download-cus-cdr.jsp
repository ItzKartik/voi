<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId"%>
<%@page import="com.kunshi.interfacef.vosweb.GetWebCdrResponse"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoTerminalLogin"%>
<%@page import="com.kunshi.interfacef.vosweb.WebQuery"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoOneCdr"%>
<%@page import="com.kunshi.platform.common.CsvExport"%>
<%@page import="com.kunshi.platform.common.FastBlockingQueue"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.platform.mgc.common.MGCMessage"%>
<%@page import="com.kunshi.platform.mgc.common.MGCMessageType"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%@page import="java.util.zip.ZipOutputStream"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.concurrent.atomic.AtomicInteger"%>
<%!
  private static final String LAST_DOWNLOAD_TIME = "LAST_DOWNLOAD_TIME";
  private static final String CURRENT_SESSION_DOWNLOADING = "CURRENT_SESSION_DOWNLOADING";
  private static final long MIN_INTERVAL = 30000;
  private static final int MAX_DOWNLOADING = 4;
  private static final AtomicInteger downloadingCount = new AtomicInteger();
  private void prcessDownload(
      final javax.servlet.http.HttpServletRequest request,
      final WebInfoTerminalLogin info,
      final javax.servlet.http.HttpServletResponse response,
      final javax.servlet.jsp.JspWriter out) throws Exception {
    WebQuery webQuery = new WebQuery();
    webQuery.customerId = info.customerId;
    webQuery.terminalName = info.terminalName;
    webQuery.terminalType = info.terminalType;
    webQuery.customerAccount = info.customerAccount;
    webQuery.customerTimeZone = info.customerTimeZone;
    webQuery.type = WebQuery.QUERY_TYPE_CUSTOMER;
    webQuery.startTime = request.getParameter("startTime");
    webQuery.stopTime = request.getParameter("stopTime");
    webQuery.callerE164 = request.getParameter("callerE164");
    webQuery.calleeE164 = request.getParameter("calleeE164");
    FastBlockingQueue<MGCMessage> responses = new FastBlockingQueue<MGCMessage>();
    MGCConfig.listenerWebServer().sendRequest(WebBodyId.DOWN_LOAD_CDR, webQuery, MGCAPIPublicValue.FM_WEB_TIMEOUT, responses);
    ZipOutputStream zipOutputStream = null;
    MGCMessage responseMessage = responses.get();
    boolean firstResponse = true;
    while (responseMessage != null) {
      if (responseMessage.get_type() == MGCMessageType.RESPONSE
          || responseMessage.get_type() == MGCMessageType.RESPONSE_PARTIAL) {
        GetWebCdrResponse webResponse = (GetWebCdrResponse) responseMessage.getBodyObject();
        if (webResponse.retCode != RetCodeValue.F_OK) {
          if (firstResponse) {
            writeError(response, ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode));
            out.clear();
            return;
          }
          else {
            zipOutputStream.write(("Failed: " + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode)).getBytes("UTF-8"));
            zipOutputStream.flush();
            zipOutputStream.close();
            return;
          }
        }
        if (firstResponse) {
          response.reset();
          response.setContentType("application/octet-stream");
          StringBuffer fileName = new StringBuffer();
          fileName.append("cdrs_");
          for(int i = 0; i < webQuery.startTime.length(); i ++)
          {
            char value = webQuery.startTime.charAt(i);
            if(value == ' ' || value == ':')
            {
              continue;
            }
            fileName.append(value);
          }
          zipOutputStream = new ZipOutputStream(response.getOutputStream());
          zipOutputStream.putNextEntry(new ZipEntry(fileName.toString() + ".txt"));
          zipOutputStream.write("startTime,callerE164,calleeE164,holdTime,fee,packageFeeTime,packageFee\r\n".getBytes());
          fileName.append("_").append(webQuery.customerAccount).append(".zip");;
          response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName.toString(), "UTF-8"));
          response.flushBuffer();
          firstResponse = false;
        }
        for (WebInfoOneCdr infoOne : webResponse.infos) {
          StringBuffer buffer = new StringBuffer();
          CsvExport.appendValue(buffer, infoOne.start);
          CsvExport.appendValue(buffer, infoOne.callerE164);
          CsvExport.appendValue(buffer, infoOne.calleeE164);
          CsvExport.appendValue(buffer,infoOne.holdTime);
          CsvExport.appendValue(buffer,infoOne.realFee);
          CsvExport.appendValue(buffer,infoOne.suiteFeeTime);
          CsvExport.appendValue(buffer,infoOne.suiteFee);
          buffer.append("\r\n");
          zipOutputStream.write(buffer.toString().getBytes("UTF-8"));
        }
        if (responseMessage.get_type() == MGCMessageType.RESPONSE) {
          zipOutputStream.write("Finish ok".getBytes());
          zipOutputStream.flush();
          zipOutputStream.close();
	  try {Thread.sleep(1000);}catch(Exception e){}
          return;
        }
        responseMessage = responses.get();
      }
      else {
        if (firstResponse) {
          response.getWriter().write(ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.F_ERROR_TIMEOUT));
          out.clear();
        }
        else {
          zipOutputStream.write("Failed".getBytes());
          zipOutputStream.flush();
          zipOutputStream.close();
	  try {Thread.sleep(1000);}catch(Exception e){}
        }
        return;
      }
    }
  }
  private void writeError(
      final javax.servlet.http.HttpServletResponse response,
      final String error) throws Exception{
    response.getWriter().write("<span style=\"color: #FF0000;font-size: 12px;\">" + error + "</span>");
  }
%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  WebInfoTerminalLogin info = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (info == null) {
    writeError(response, ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_FAILED));
    out.clear();
    return;
  }
  Long lastDownloadTime = (Long) session.getAttribute(LAST_DOWNLOAD_TIME);
  if (lastDownloadTime != null && lastDownloadTime > (System.currentTimeMillis() - MIN_INTERVAL)) {
    writeError(response, ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.F_ERROR_SYSTEM_BUSY));
    out.clear();
    return;
  }
  if (session.getAttribute(CURRENT_SESSION_DOWNLOADING) != null) {
    writeError(response, ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.F_ERROR_SYSTEM_BUSY));
    out.clear();
    return;
  }
  try {
    if (downloadingCount.incrementAndGet() > MAX_DOWNLOADING) {
      writeError(response, ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.F_ERROR_SYSTEM_BUSY));
      out.clear();
      return;
    }
    session.setAttribute(LAST_DOWNLOAD_TIME, System.currentTimeMillis());
    session.setAttribute(CURRENT_SESSION_DOWNLOADING, "");
    prcessDownload(request, info, response, out);
  }
  finally {
    downloadingCount.decrementAndGet();
    session.removeAttribute(CURRENT_SESSION_DOWNLOADING);
  }
%>
