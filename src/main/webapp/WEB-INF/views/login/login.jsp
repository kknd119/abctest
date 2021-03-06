﻿<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--
http://stackoverflow.com/questions/5603117/jquery-create-object-from-form-fields
-->

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>폼 데이터를 JSON 형태로 변환</title>
    <style>
        div { font-weight: bold; color:red; }

        .profile { position: relative; z-index: 10; zoom: 1; border: 1px solid #dcdcdc; border-bottom: 0; height: 99px; _width: 298px } 
        .profile .user_area { background-color: #f3f4f3; border-bottom: 1px solid #dcdcdc; height: 54px; position: relative; z-index: 10 } 
        .profile .user_info { position: relative; padding: 8px 0 4px 58px; zoom: 1 } 
        .profile .user_thumbnail { position: absolute; left: 11px; top: 5px; width: 42px; height: 42px; overflow: hidden } 
        .profile .user_thumbnail img { width: auto; height: auto; max-width: 100%; max-height: 100% } 
        .profile .user_thumbnail .mask { width: 100%; height: 100%; position: absolute; left: 0; top: 0 } 

        .profile .private { margin-bottom: 5px; line-height: 19px; white-space: nowrap; position: relative } 
        .profile .private .user_name { max-width: 90px; *width: 90px; vertical-align: middle; position: relative; overflow: hidden; box-sizing: content-box; margin-right: 6px } 
        .profile .private .user_name a { color: #2f3743; font-weight: bold } 
        .profile .private .user_name a:hover { text-decoration: none } 
        .profile .private .user_name a strong { max-width: 79px; *width: 79px; vertical-align: top; *vertical-align: middle } 
        .profile .private .user_name a:hover strong { text-decoration: underline } 
        .profile .private .login_on { width: 17px; height: 11px; margin: 4px 2px 0 0; overflow: hidden; background-position: -20px -340px; vertical-align: top } 
        .profile .private .link_myinfo { color: #848688; text-decoration: underline } 
        .profile .private .set_login_protect { width: 12px; height: 18px; background-position: -58px 4px; vertical-align: top; margin-left: -1px } 
        .profile .private .btn_logout { position: absolute; right: 12px; border: 1px solid #d1d1d1; color: #848688; height: 16px; overflow: hidden; vertical-align: top } 
        .profile .private .btn_logout .btn_inr { border: 1px solid #fff; border-right: 0; border-bottom: 0; background-color: #f6f7f8; padding: 0 4px 0; height: 15px; line-height: 15px; vertical-align: top; *line-height: 17px } 

        .bar { width: 1px; height: 16px; background-position: 100% -18px; vertical-align: top; overflow: hidden }

    </style>
    <script src="../jquery-3.1.0.js"></script>
    <script>
        /*
         검색조건: jquery form filed object
         http://stackoverflow.com/questions/5603117/jquery-create-object-from-form-fields
         사용법:  var obj = serializeJSON( $(form).serializeArray() );
         */
        var serializeJSON = function (arr) {

            // var arr = $(form).serializeArray();
            var obj = {};

            for(var i = 0; i < arr.length; i++) {
                if(obj[arr[i].name] === undefined) {
                    obj[arr[i].name] = arr[i].value;
                } else {
                    if(!(obj[arr[i].name] instanceof Array)) {
                        obj[arr[i].name] = [obj[arr[i].name]];
                    }
                    obj[arr[i].name].push(arr[i].value);
                }
            }
            return obj;
        };

        $(document).ready(function(e){
            $('#submit').click( function(e){
                // input 태그의 name 속성과 value 속성을이용해서 객체 만들기
                var form_data = serializeJSON(  $('form').serializeArray()  );
                console.log(form_data);

                // 객체를 문자열로 출력.
                var str = JSON.stringify(form_data);
                $('#result').html( str );

                // ajax 로 호출. http://localhost:3000/login
               $.ajax({
                   url : 'http://localhost:3000/login',
                   data: form_data,        // 사용하는 경우에는 { data1:'test1', data2:'test2' }
                   type: 'post',       // get, post
                   timeout: 30000,    // 30초
                   dataType: 'json',  // text, html, xml, json, jsonp, script
                   beforeSend : function() {
                       // 통신이 시작되기 전에 이 함수를 타게 된다.
                       $('#result').append('<img src="./loading.gif">');
                   }
               }).done( function(data, textStatus, xhr ){
                   // 통신이 성공적으로 이루어졌을 때 이 함수를 타게 된다.
                   $('div.profile').show();
                   $('#user_name').text(data.username);

                   $('div.login').hide();
               }).fail( function(xhr, textStatus, error ) {
                   // 통신이 실패했을 때 이 함수를 타게 된다.
                   var msg ='';
                   msg += "code:"    + xhr.status         + "\n";
                   msg += "message:" + xhr.responseText   + "\n";
                   msg += "status:"  + textStatus         + "\n";
                   msg += "error  : "+ error              + "\n";
                   console.log(msg);
               }).always( function(data, textStatus, xhr ) {
                   // 통신이 실패했어도 성공했어도 이 함수를 타게 된다.
                   $("#result > img").remove();
               });

               return false;
          });
        });
    </script>
</head>
<body>

    <div class="login">
        <form>
            <input type="hidden" name="seq" value="1">
            <label> 이름을 입력하세요 : </label>
            <input type="text" name="username" value="${username}"/>  <br/>
            <label> 패스워드를 입력하세요 :</label>
            <input type="password"  name="password" value="${password}" />  <br/>
            <input type="checkbox" name="hobby" value="music"> music
            <input type="checkbox" name="hobby" value="yoga"> yoga
            <input type="checkbox" name="hobby" value="reading"> reading <br/>
            <input type="button" id="submit" value="전송"/>
        </form>
    </div>

    <div class="profile" style="display: none;">
        <div class="user_area">
            <div class="user_info">
                <a href="#" class="user_thumbnail">
                    <span class="mask"></span>
                    <img id="profile_image" src="myInfo.gif">
                </a>
                <div class="private">
                    <span class="user_name"><a href="#"><strong id="user_name">???</strong>님</a></span>
                    <a href="#" target="_parent" class="link_myinfo">내정보</a>
                    <a href="http://nid.naver.com/nidlogin.logout?returl=http://www.naver.com" target="_parent" class="btn_logout">
                        <span class="btn_inr">로그아웃</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <hr>
    <div id="result"></div>
</body>
</html>