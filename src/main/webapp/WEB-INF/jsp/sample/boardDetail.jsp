<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html> 
<html lang="ko"> 
<head> 
<%@ include file="/WEB-INF/include/include-header.jspf" %> 
</head> 
<body>
	<table class="board_view"> 
		<colgroup> 
			<col width="15%"/> 
			<col width="35%"/> 
			<col width="15%"/> 
			<col width="35%"/> 
		</colgroup> 
		<caption>자산목록 상세</caption> 
		<tbody> 
			<tr> 
				<th scope="row">글 번호</th> 
					<td>${map.IDX }</td> 
				<th scope="row">조회수</th> 
					<td>${map.HIT_CNT }</td> 
			</tr> 
			<tr> 
				<th scope="row">작성자</th> 
					<td>${map.CREA_ID }</td> 
				<th scope="row">작성시간</th> 
					<td>${map.CREA_DTM }</td> 
			</tr> 
			<tr> 
				<th scope="row">제목</th> 
					<td colspan="3">${map.TITLE }</td> 
			</tr> 
			<tr> 
					<td colspan="4">${map.CONTENTS }</td> 
			</tr> 
			<tr> 
				<th scope="row">첨부파일</th>
					<td colspan="3">
						<c:forEach var="row" items="${list }">
							<input type="hidden" id="IDX" value="${row.IDX }">
							<a href="#this" name="file">${row.ORIGINAL_FILE_NAME }</a>
							(${row.FILE_SIZE }kb)
						</c:forEach>
					</td>
			</tr> 
		</tbody> 
	</table> 

    <form id="frm">
        <table class="board_view">
            <colgroup>
                <col width="15%">
                <col width="85%">
            </colgroup>
            <tbody>
                <tr>
                    <th>댓글</th>
                    <td>
                        ${fn:length(comment) }
                    </td>
                </tr>
                <c:if test="${fn:length(comment)>0 }">
                    <c:forEach items="${comment }" var="com">
                        <tr>
                            <td style="background:#f7f7f7;color:#3b3a3a;" >
                                ${com.CREA_ID }
                                <p style="font-size: 8px;" >${com.CREA_DTM }</p>
                            </td>
                            <td>
                                <input type="hidden" value="${com.IDX }" id="com_IDX">
                                <div id="com_Div"><input type="hidden" value ="${com.CONTENTS}" id="com_CON">${com.CONTENTS }</div>
                                <c:if test="${com.CREA_ID==userInfo.uid }">
                                    <div align="right">
                                        <a href="#this" name="com_Del" class="btn">삭제</a>
                                        <a href="#this" name="com_Mod" class="btn">수정</a>
                                    </div>                            
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${! empty userInfo }">
                    <tr>
                        <td colspan="2">
                            <div>
                                ${userInfo.uid}
                                <input type="hidden" name="CREA_ID" value="${userInfo.uid }"/>
                                 
 
 
                                <textarea  rows="5" cols="130" name="COM_CONTENTS" ></textarea>
                                <p align="right" ><a href="#this" id="com_write" class="btn">등록</a></p>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </form>
    
	<a href="#this" class="btn" id="list">목록으로</a> 
	<c:if test="${userInfo.uid==map.CREA_ID }">
      <a href="#this" id="update" class="btn">수정하기</a>
    </c:if> 

	
	<%@ include file="/WEB-INF/include/include-body.jspf" %> 
	<script type="text/javascript"> 
		$(document).ready(function(){ 
			$("#list").on("click", function(e){ //목록으로 버튼 
				e.preventDefault(); 
				fn_openBoardList(); 
				
			}); 
			
			$("#update").on("click", function(e){ //수정하기 버튼
				e.preventDefault(); 
				fn_openBoardUpdate(); 
				
			});
			
			$("a[name='file']").on("click", function(e){ //파일 이름
				e.preventDefault(); 
				fn_downloadFile($(this));
				
			});
			
            $("#com_write").on("click",function(e){
                e.preventDefault();
                fn_writeComment();
            });
            $("a[name=com_Del]").on("click",function(e){
                e.preventDefault();
                fn_deleteComment($(this));
            });
            $("a[name=com_Mod]").on("click",function(e){
                e.preventDefault();
                fn_commentModify($(this));
            });
		}); 
		
		function fn_openBoardList(){ 
			var comSubmit = new ComSubmit(); 
			comSubmit.setUrl("<c:url value='/sample/openBoardList.do' />"); 
			comSubmit.submit(); 
			
		} 
		
		function fn_openBoardUpdate(){ 
			var idx = "${map.IDX}";
			var comSubmit = new ComSubmit(); 
			comSubmit.setUrl("<c:url value='/sample/openBoardUpdate.do' />"); 
			comSubmit.addParam("IDX", idx);
			comSubmit.submit(); 
			
		} 
		
		function fn_downloadFile(obj){ 
			var idx = obj.parent().find("#IDX").val();
			var comSubmit = new ComSubmit(); 
			comSubmit.setUrl("<c:url value='/common/downloadFile.do' />"); 
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
			$("#commonForm").children().remove();
			
		} 
		
        function fn_writeComment(){
            var comSubmit = new ComSubmit("frm");
            comSubmit.addParam("IDX",${map.IDX})
            comSubmit.setUrl("<c:url value='/sample/writeComment.do'/>");
            comSubmit.submit();
        }
 
        function fn_deleteComment(obj){
            var comSubmit = new ComSubmit();
            comSubmit.addParam("IDX",${map.IDX})
            comSubmit.addParam("COM_IDX",obj.parent().parent().find("#com_IDX").val());
            comSubmit.setUrl("<c:url value='/sample/deleteComment.do'/>");
            comSubmit.submit();
        }
 
        function fn_commentModify(obj){
            var con = obj.parent().parent().find("#com_Div").find("#com_CON").val();
            var str = "<textarea  rows='5' cols='100' name='COM_CONTENTS_UPD'>"+con+"</textarea><p align='right' ><a href=''#this' name='com_Upd' class='btn'>등록</a></p><hr/>";
            var div = obj.parent().parent().find("#com_Div");
 
            div.empty();
            div.append(str)
             
            $("a[name=com_Upd]").on("click",function(e){
                e.preventDefault();
                fn_updateComment($(this));
            })
        }
 
        function fn_updateComment(obj){
            var comSubmit = new ComSubmit("frm");
            comSubmit.addParam("IDX",${map.IDX})
            comSubmit.addParam("COM_IDX",obj.parent().parent().parent().find("#com_IDX").val());
            comSubmit.setUrl("<c:url value='/sample/updateComment.do'/>");
            comSubmit.submit();
        }

	</script> 
</body> 
</html>
		

	