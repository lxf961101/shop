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
                "<%=request.getContextPath()%>/shop/list",
                $("#fm").serialize(),
                function(data){
                    totalNum = data.data.totalNum;
                    var html = "";
                    for (var i = 0; i < data.data.shopList.length; i++) {
                        var s = data.data.shopList[i];
                        html += "<input type = 'hidden' id = '"+s.id+"' value = '"+s.status+"'>";
                        html += "<tr>"
                        html += "<td><input type = 'checkbox' name = 'id' value = '"+s.id+"'>";
                        html += "<td>"+s.productName+"</td>"
                        html += "<td>"+s.price+"</td>"
                        html += s.status == 1 ? "<td>上架</td>" : "<td>下架</td>"
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


        //批量刪除
        function delByIds(){
            var length = $("input[name='id']:checked").length;
            if(length <= 0){
                layer.msg('请至少选择一个!', {icon:0});
                return;
            }
            var str = "";
            $("input[name='id']:checked").each(function (index, item) {
                if ($("input[name='id']:checked").length-1==index) {
                    str += $(this).val();
                } else {
                    str += $(this).val() + ",";
                }
            });
            var id = $("input[name='id']:checked").val();
            layer.confirm('确定恢复吗?', {icon: 3, title:'提示'}, function(index){
                var index = layer.load(1,{shade:0.5});
                $.post("<%=request.getContextPath()%>/shop/delByIds",
                    {"ids":str,"isDel": 1},
                    function(data){
                        if(data.code == 200){
                            layer.msg(data.msg, {
                                icon: 6,
                                time: 2000 //2秒关闭（如果不配置，默认是3秒）
                            }, function(){
                                window.location.href = "<%=request.getContextPath()%>/shop/toDelRenew";
                            });
                            return;
                        }
                        layer.msg(data.msg, {icon:5});
                        layer.close(index);
                    });
            });
            layer.close(index);
        }

    </script>
</head>
<body>
<form id="fm">
    <input type="hidden" value="1" id="pageNo" name="pageNo">
    <input type="hidden" value="-1"  name="isDel">
    <input type="text" name="produceName" value="" placeholder="请输入商品名"><br />
    价格：<input type="text" name = "price" placeholder="最小"/>
    ~<input type="text" name = "price1" placeholder="最大"/>
    <input type="button" value="查询" onclick="search()"><br />
</form>
        <shiro:hasPermission name="shop:del">
            <input type="button" value="恢复" onclick="delByIds()">&nbsp;
        </shiro:hasPermission>
    <table border="1px">
        <tr>
            <th></th>
            <th>商品名称</th>
            <th>商品价格</th>
            <th>状态</th>

        </tr>
        <tbody id="tbd">

        </tbody>
    </table>

<div id="pageInfo">

</div>
</body>
</html>
