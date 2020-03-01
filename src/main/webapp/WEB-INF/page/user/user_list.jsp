<%--
  Created by IntelliJ IDEA.
  User: ZhangJQ
  Date: 2020/1/29
  Time: 17:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
    <script type="text/javascript">

        var totalNum = 0;

        $(function(){
            search();
        })

        function search() {
            $.post(
                "<%=request.getContextPath()%>/user/list",
                $("#fm").serialize(),
                function(data){
                    totalNum = data.data.totalNum;
                    var html = "";
                    for (var i = 0; i < data.data.userList.length; i++) {
                        var u = data.data.userList[i];
                        html += "<tr>"
                        html += "<td><input type = 'checkbox' name = 'id' value = '"+u.id+"'>";
                        html += "<td>"+u.username+"</td>"
                        html += u.sex == 1 ? "<td>男</td>" : "<td>女</td>"
                        html += "<td>"+u.phone+"</td>"
                        html += "<td>"+u.email+"</td>"
                        if (u.role == 3) {
                            html += "<td>管理员</td>"
                        } else if (u.role == 2) {
                            html += "<td>商家</td>"
                        } else {
                            html += "<td>普通用户</td>"
                        }
                        html += "</tr>"
                    }
                    $("#tbd").html(html);
                    var pageNo = $("#pageNo").val();
                    var pageHtml = "<input type='button' value='上一页' onclick='page("+(parseInt(pageNo) - 1)+")'>";
                    pageHtml += "<input type='button' value='下一页' onclick='page("+(parseInt(pageNo) + 1)+")')'>";
                    $("#pageInfo").html(pageHtml);
                }
            )
        }

        function page(page) {

            if (page < 1) {
                layer.msg('首页啦!', {icon:0});
                return;
            }
            if (page > totalNum) {
                layer.msg('已经到尾页啦!!', {icon:0});
                return;
            }
            $("#pageNo").val(page);
            search();

        }

        //去修改
        function updateById(){
            var length = $("input[name='id']:checked").length;

            if(length <= 0){
                alert("至少选择一项");
                return;
            }
            if(length > 1){
                alert("只能选择一个");
                return;
            }

            var id = $("input[name='id']:checked").val();
            layer.confirm('确定修改吗?', {icon: 3, title:'提示'}, function(index){
                //do something

                layer.close(index);

                layer.open({
                    type: 2,
                    title: '修改页面',
                    shadeClose: true,
                    shade: 0.8,
                    area: ['380px', '90%'],
                    content: '<%=request.getContextPath()%>/user/toUpdate/'+id
                });
            });
        }


        //删除
        function delById(){
            var length = $("input[name='id']:checked").length;

            if(length <= 0){
                alert("至少选择一项");
                return;
            }
            if(length > 1){
                alert("只能选择一个");
                return;
            }

            var id = $("input[name='id']:checked").val();
            var index = layer.load(1,{shade:0.5});
            layer.confirm('确定删除吗?', {icon: 3, title:'提示'}, function(index){
                //do something
                $.post(
                    "<%=request.getContextPath()%>/user/delById",
                    {"id": id, "isDel": -1},
                    function(data){
                        if (data.code != -1) {
                            layer.msg(data.msg, {icon: 6}, function(){
                                window.location.href = "<%=request.getContextPath()%>/user/toList";
                            });
                            return;
                        }
                        layer.msg(data.msg, {icon: 5})
                        layer.close(index);
                    }
                )
            });
            layer.close(index);
        }


        function add(){
            layer.confirm('确定新增吗?', {icon: 3, title:'提示'}, function(index){
                //do something
                layer.open({
                    type: 2,
                    title: '新增页面',
                    shadeClose: true,
                    shade: 0.8,
                    area: ['380px', '90%'],
                    content: '<%=request.getContextPath()%>/shop/toAdd'
                });
            });
        }

        //授权
        function updateRoleById(){
            var length = $("input[name='id']:checked").length;

            if(length <= 0){
                alert("至少选择一项");
                return;
            }
            if(length > 1){
                alert("只能选择一个");
                return;
            }

            var id = $("input[name='id']:checked").val();

            layer.open({
                type: 2,
                title: '修改页面',
                shadeClose: true,
                shade: 0.8,
                area: ['380px', '90%'],
                content: '<%=request.getContextPath()%>/user/toUpdateRoleById/'+id
            });
        }
    </script>
</head>
<body>
<form id="fm">
    <input type="hidden" value="1" id="pageNo" name="pageNo">
    <input type="hidden" value="1"  name="isDel">
    <input type="text" name="username" value="" placeholder="请输入用户名/手机号/邮箱"><br />
    性别:
        男:<input type="radio" name="sex" value="1">
        女:<input type="radio" name="sex" value="2"> <br />
    角色:
        <select name="role">
            <option value="">请选择</option>
            <option value="1">普通用户</option>
            <option value="2">商家</option>
            <option value="3">管理员</option>
        </select>

    <input type="button" value="查询" onclick="search()"><br />
</form>
        <shiro:hasPermission name="user:update">
            <input type="button" value="修改" onclick="updateById()">&nbsp;&nbsp;
        </shiro:hasPermission>
        <shiro:hasPermission name="user:del">
            <input type="button" value="删除" onclick="delById()">&nbsp;
        </shiro:hasPermission>
        <shiro:hasPermission name="user:updRole">
            <input type="button" value="授权" onclick="updateRoleById()">&nbsp;
        </shiro:hasPermission>
    <table border="1px">
        <tr>
            <th></th>
            <th>用户名</th>
            <th>性别</th>
            <th>手机号</th>
            <th>邮箱</th>
            <th>角色</th>

        </tr>
        <tbody id="tbd">

        </tbody>
    </table>

<div id="pageInfo">

</div>
</body>
</html>
