<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
<head>
<title>SEEDIT | Log in</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css'/>" /> 
</head>
<body>
   
        <form id="frm" class="box" onsubmit="JavaScript:fn_loginUser();"  >
        	<h1>LOGIN</h1>
                <input type="text" class="input_text" name="UID" maxlength="15" placeholder="Username" value="" id="uid">
                <input type="password" class="input_text" name="UPW" maxlength="15" placeholder="Password" value="" id="upw">

            <c:if test="${error}">
                아이디나 비밀번호가 일치하지 않습니다.           
            </c:if>
            <button type="submit" class="btn con_center">Login</button>
 
        </form>
    
</body>
    <%@ include file="/WEB-INF/include/include-body.jspf" %>
    <script type="text/javascript">
         
        function fn_loginUser(){
            var comSubmit = new ComSubmit("frm");
            comSubmit.setUrl("<c:url value='/sample/loginUser.do'/>");
            comSubmit.submit();
        }
         
    </script>
</html>