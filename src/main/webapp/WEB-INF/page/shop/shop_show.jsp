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
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/jquery.validate.js"></script>
    <script src="https://static.runoob.com/assets/jquery-validation-1.14.0/dist/localization/messages_zh.js"></script>
    <script type="text/javascript">

        var totalNum = 0;

        $(function(){
            search();
        })

        function search() {
            $.post(
                "<%=request.getContextPath()%>/shop/show",
                $("#fm").serialize(),
                function(data){
                    totalNum = data.data.totalNum;
                    var html = "";
                    for (var i = 0; i < data.data.shopList.length; i++) {
                        var s = data.data.shopList[i];
                        html += "<tr>"
                        html += "<td><input type = 'checkbox' name = 'id' value = '"+s.id+"'>";
                        html += "<td>"+s.productName+"</td>"
                        html += "<td>"+s.price+"</td>"
                        html += "<td>"+s.number+"</td>"
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

        //补货
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
            layer.confirm('确定对其进行补货吗?', {icon: 3, title:'提示'}, function(index){
                //do something

                layer.close(index);

                layer.open({
                    type: 2,
                    title: '补货页面',
                    shadeClose: true,
                    shade: 0.8,
                    area: ['380px', '90%'],
                    content: '<%=request.getContextPath()%>/shop/toUpdateNumber/'+id
                });
            });
            layer.close(index);
        }


        //购买
        function add(){
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
            $("#shopId").val(id);
            layer.confirm('确定购买吗?', {icon: 3, title:'提示'}, function(index){
                //do something
                var index = layer.load(1,{shade:0.5});
                $.post("<%=request.getContextPath()%>/shop/addUserShop",
                    $("#fm1").serialize(),
                    function(data){
                        if(data.code == 200){
                            layer.msg(data.msg, {
                                icon: 6,
                                time: 2000 //2秒关闭（如果不配置，默认是3秒）
                            }, function(){
                                //do something
                                window.location.href="<%=request.getContextPath()%>/shop/toShow";
                            });
                            return;
                        }
                        layer.msg(data.msg, {icon: 5});
                        layer.close(index);
                    })
            });
            layer.close(index);
        }

        $.validator.setDefaults({
            submitHandler: function() {
                var index = layer.load(1,{shade:0.5});
                var length = $("input[name='id']:checked").length;

                if(length <= 0){
                    alert("至少选择一项");
                    layer.close(index);
                    return;
                }
                if(length > 1){
                    alert("只能选择一个");
                    layer.close(index);
                    return;
                }
                var id = $("input[name='id']:checked").val();
                $("#shopId").val(id);
                $.post("<%=request.getContextPath()%>/shop/addUserShop",
                    $("#fm1").serialize(),
                    function(data){
                        if(data.code == -1){
                            layer.close(index);
                            layer.msg(data.msg, {icon: 5});
                            return
                        }
                        layer.msg(data.msg, {
                            icon: 6,
                            time: 2000
                        }, function(){
                            window.location.href = "<%=request.getContextPath()%>/shop/toShow";
                        });
                    }
                )
                /*  });
                 layer.close(index); */
            }
        });

        $(function(){
            $("#fm1").validate({
                //效验规则
                rules: {
                    number:{
                        required:true,
                    },
                },
                messages:{
                    productName:{
                        required:"数量必填",
                    },
                },
            })
        })

        //充值
        function addMoney(){
            layer.confirm('确定充值吗?', {icon: 3, title:'提示'}, function(index){
                //do something

                layer.close(index);

                layer.open({
                    type: 2,
                    title: '充值页面',
                    shadeClose: true,
                    shade: 0.8,
                    area: ['380px', '90%'],
                    content: '<%=request.getContextPath()%>/shop/toUpdateMoney/'+${user.id}
                });
            });
        }
        
        $(function () {
            $.post("<%=request.getContextPath()%>/shop/getMoneyById/"+${user.id},
                $("#fm1").serialize(),
                function(data){
                    $("#money").append(data.data);
                }
            )
        })
    </script>
</head>
<body>
<div align="right">
    剩余金额:<span id="money"></span>
</div>
<form id="fm">
    <input type="hidden" value="1" id="pageNo" name="pageNo">
    商品名:<input type="text" name="produceName" value="" placeholder="请输入商品名"><br />
    价格：<input type="text" name = "price" placeholder="最小"/>
    ~<input type="text" name = "price1" placeholder="最大"/><br />
    <input type="button" value="查询" onclick="search()"><br />
</form>
        <shiro:hasPermission name="shop:addNumber">
            <input type="button" value="补货" onclick="updateById()">&nbsp;&nbsp;
        </shiro:hasPermission>
        <shiro:hasPermission name="shop:buy">
            <form id="fm1">
                <input type="hidden" name="userId" value="${user.id}" >
                <input type="hidden" name="shopId" id="shopId">
                <input type="submit" value="购买">&nbsp;&nbsp;
                <input type="text" name="number" oninput="value=value.replace(/[^\d]/g,'').replace(/^0{1,}/g,'')" placeholder="请输入数量" maxlength="6" id="number"><br />
                <input type="button" value="充值" onclick="addMoney()">
            </form>
        </shiro:hasPermission>
    <table border="1px">
        <tr>
            <th></th>
            <th>商品名称</th>
            <th>商品价格</th>
            <th>库存</th>
        </tr>
        <tbody id="tbd">

        </tbody>
    </table>

<div id="pageInfo">

</div>
</body>
</html>
