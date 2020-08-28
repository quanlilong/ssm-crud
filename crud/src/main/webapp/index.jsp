<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <title>员工李列表</title>

    <%--    web路径：
    不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题
    以/开始的相对路径，找资源，以服务器的根路径为基准(http://localhost:3306),需要加上项目名
    或者加入base标签
    --%>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.4.1.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

</head>
<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--                            部门提交部门id即可--%>
                            <select class="form-control" name="dId" id="dept_update_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10" id="emp_add_gender">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
<%--                            部门提交部门id即可--%>
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>


<%--搭建显示页面--%>
<div class="container">
    <%--标题    --%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <%--按钮        --%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary btn-sm" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger btn-sm" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <%--        表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" id="check_all">
                        </th>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>



            </table>
        </div>
    </div>
    <%--        显示分页信息--%>
    <div class="row">
        <%--        分页文字信息--%>
        <div class="col-md-6" id="page_info_area">

        </div>
        <%--分页条信息--%>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>

</div>



<script type="text/javascript">
    var totalRecord;//全局变量：总记录数
    var currentPage;//当前页
    //1.页面加载完成以后，直接去发送ajax请求，要到分页数据
    $(function () {
        //去首页
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"get",
            success:function (resp) {
                //1.解析并显示员工数据
                build_emps_table(resp)
                //2.解析并显示分页信息
                build_page_info(resp)
                //3.解析显示分页条
                build_page_nav(resp)
            }
        })
    }

    function build_emps_table(resp) {
        //每次请求前清空table表格
        $("#emps_table tbody").empty();
        var emps=resp.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var checkBoxTd=$("<td><input type='checkbox' class='check_item'/></td>")
            var empIdTd=$("<td></td>").append(item.empId);
            var empNameTd=$("<td></td>").append(item.empName);
            var genderTd=$("<td></td>").append(item.gender=='M'?'男':'女');
            var emailTd=$("<td></td>").append(item.email);
            var deptNameTd=$("<td></td>").append(item.department.deptId);
            var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn").append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑")
            //为编辑按钮添加一个自定义的属性，来表示当前员工id
            editBtn.attr("edit-id",item.empId);
            var delBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn").append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除")
            //为删除按钮天界一个自定义的属性来表示当前删除的员工id
            delBtn.attr("del-id",item.empId);
            var btnTd=$("<td></td>").append(editBtn).append(" ").append(delBtn)
            $("<tr></tr>")
                .append(checkBoxTd)
                .append(empIdTd).append(empNameTd)
                .append(genderTd).append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody")
        })
    }
    //解析显示分页信息
    function build_page_info(resp) {
        $("#page_info_area").empty();
        $("#page_info_area").append("当前"+resp.extend.pageInfo.pageNum+"页,总共"+resp.extend.pageInfo.pages+"页,总共"+
            resp.extend.pageInfo.total+"条记录")
        totalRecord=resp.extend.pageInfo.total;
        currentPage=resp.extend.pageInfo.pageNum;
    }
    //解显示分页条,点击分页要能去下一页。。。
    function build_page_nav(resp) {
        $("#page_nav_area").empty();
        var ul=$("<ul></ul>").addClass("pagination");
        //构建元素
        var firstPageLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi=$("<li></li>").append($("<a></a>").append("&laquo;"));
        if(resp.extend.pageInfo.hasPreviousPage==false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //为元素添加单击翻页的事件
            firstPageLi.click(function () {
                to_page(1)
            });
            prePageLi.click(function () {
                to_page(resp.extend.pageInfo.pageNum - 1);
            });
        }

        var nextPageLi=$("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi=$("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if(resp.extend.pageInfo.hasNextPage==false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled")
        }else{
            nextPageLi.click(function () {
                to_page(resp.extend.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(resp.extend.pageInfo.pages);
            })
        }

        //添加首页和前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        //1,2,3,4,5遍历给ul中添加页码提示
        $.each(resp.extend.pageInfo.navigatepageNums,function (i,n) {
            var numLi=$("<li></li>").append($("<a></a>").append(n));
            if(resp.extend.pageInfo.pageNum==n){
                numLi.addClass("active")
            }
            numLi.click(function () {
                to_page(n)
            })
            ul.append(numLi);
        });
        //添加下一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);
        //把ul加入到nav元素
        var navEle=$("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    //清空表单样式及内容
    function rest_form(ele){
        $(ele)[0].reset();
        //清空表达样式
        $(ele).find("*").removeClass("has-success has-error");
        $(ele).find(".help-block").text("");
    }

    //点击新增弹出模态框
    $("#emp_add_modal_btn").click(function () {
        //清楚表单数据(表单完整重置,表单的样式数据等)
        rest_form("#empAddModal form");
        //发生ajax请求，查出部门信息，显示在下拉列表中
        getDepts("#dept_add_select");
        //弹出模态框
        $('#empAddModal').modal({
            backdrop:"static"
        });
    });
    //查出所有的部门信息
    function getDepts(ele) {
        //清空之前下拉列表的值
        $(ele).empty();
        $.ajax({
            url:"${APP_PATH}/depts",
            async:false,
            type:"get",
            success:function (resp) {
                // console.log(resp)
                // $("#dept_add_select").append("")
                $.each(resp.extend.depts,function (i,n) {
                    var optionEle=$("<option></option>").append(n.deptName).attr("value",n.deptId)
                    optionEle.appendTo(ele)
                })
            }
        })
    }
        //校验表单数据
        function validata_add_form(){
            //1.拿到要校验的数据，使用正则表达式
            var empName=$("#empName_add_input").val();
            var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
           if(!regName.test(empName)){
               //alert("用户名可以是2-5位中文或者6-16位英文和数字的组合")
               show_validata_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字的组合");
               return false;
           }else{
               show_validata_msg("#empName_add_input","success","");
           };
            //2.校验邮箱
            var email= $("#email_add_input").val();
            var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(!regEmail.test(email)){
                //alert("邮箱格式不正确")
                //应该清空这个元素之前的样式
                show_validata_msg("#email_add_input","error","邮箱格式不正确");
                // $("#email_add_input").parent().addClass("has-error");
                // $("#email_add_input").next("span").text("邮箱格式不正确");
                return false;
            }else{
                show_validata_msg("#email_add_input","success","")
                // $("#email_add_input").parent().addClass("has-success");
                // $("#email_add_input").next("span").text("");
            }
            return true;
        }


        function show_validata_msg(ele,status,msg){
            //清楚当前元素校验状态
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if("success"==status){
                $(ele).parent().addClass("has-success")
                $(ele).next("span").text(msg);
            }else if("error"==status){
                $(ele).parent().addClass("has-error")
                $(ele).next("span").text(msg);
            }
        }
        //校验用户名是否可用，给文本框绑定change事件
        $("#empName_add_input").change(function () {
            //发生ajax请求校验用户名是否可用
            $.ajax({
                url:"${APP_PATH}/checkUser",
                data:"empName="+$("#empName_add_input").val(),
                type:"post",
                success:function (resp) {
                    if(resp.code==100){
                        show_validata_msg("#empName_add_input","success","用户名可用");
                        $("#emp_save_btn").attr("ajax-va","success");
                    }else{
                        show_validata_msg("#empName_add_input","error",resp.extend.va_msg);
                        $("#emp_save_btn").attr("ajax-va","error");
                    }
                }
            })

        })

        //点击保存，保存员工
    $("#emp_save_btn").click(function () {
        //1.将模态框中填写的表单数据提交给服务器进行保存
        //先对要提交给服务器的数据进行校验
        if(!validata_add_form()){
            return false; //如果验证失败，就不执行这个函数了
        }
        //1.判断之前的ajax用户名校验是否成功。
        if($("#emp_save_btn").attr("ajax-va")=="error"){
            return false;
        }
        //2.发生ajax请求保存员工
        $.ajax({
            url:"${APP_PATH}/emp",
            type:"post",
            data:{
                "empName":$("#empName_add_input").val(),
                "email":$("#email_add_input").val(),
                "gender":$("#emp_add_gender input:radio:checked").val(),
                "dId":$("#dept_add_select option:selected").val()
            },
            success:function (resp) {
                if(resp.code==100){
                    //员工保存成功
                    //1.关闭模态框
                    $('#empAddModal').modal('hide')
                    //2.来到最后一页，显示刚才保存的数据
                    //发送ajax请求显示最后一页数据
                    to_page(totalRecord);//总记录记录数肯定大于总页码
                }else{
                    //显示失败信息
                    // console.log(resp)
                    //有哪个字段的错误信息就显示哪个字段的
                    if(undefined!=resp.extend.errorFields.email){
                        //显示邮箱错误信息
                        show_validata_msg("#email_add_input","error",resp.extend.errorFields.email)
                    }
                    if(undefined!=resp.extend.errorFields.empName){
                        //显示员工名字的错误信息
                        show_validata_msg("#empName_add_input","error",resp.extend.errorFields.empName)
                    }
                }

            }
        })
    })


    //1.我们是按钮创建之前就绑定了click，所以绑定不上
        //1所以在创建按钮的时候绑定单击事件
    // 2.绑定点击 .live(),jQuery新版没有live，使用on进行替代
    $(document).on("click",".edit_btn",function () {
        // alert("edit")
        //1.弹出模态框之前查出部门信息，并显示部门列表
        getDepts("#empUpdateModal select")
        //查出员工信息，显示员工信息
        getEmp($(this).attr("edit-id"));

        //把员工的id传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
        //2.弹出模态框
        $('#empUpdateModal').modal({
            backdrop:"static"
        });
    });

    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"get",
            success:function (resp) {
                // console.log(resp);
                var empData=resp.extend.emp;
                $("#empName_update_static").text(empData.empName)
                $("#email_update_input").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId])
            }

        })
    }

    //点击更新，更新员工信息
    $("#emp_update_btn").click(function () {
            //验证邮箱是否合法
        //2.校验邮箱
        var email= $("#email_update_input").val();
        var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            show_validata_msg("#email_update_input","error","邮箱格式不正确");
            return false;
        }else{
            show_validata_msg("#email_update_input","success","")
        }
        //2.发生ajax请求保存更新的员工
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            type:"post",
            data:$("#empUpdateModal form").serialize()+"&_method=PUT",
            success:function (resp) {
                // alert(resp.msg)
                //1.关闭对话框
                $("#empUpdateModal").modal("hide");
                //2.回到本页面
                to_page(currentPage);
            }
        })
    })

    //单个删除
    $(document).on("click",".delete_btn",function () {
        //1.弹出是否确认删除对话框
        var empName=$(this).parents("tr").find("td:eq(2)").text()
        var empId=$(this).attr("del-id");
        // alert($(this).parents("tr").find("td:eq(1)").text());
        if(confirm("确认删除【"+empName+"】吗?")){
            //确认，发送ajax请求删除即可
            $.ajax({
                url:"${APP_PATH}/emp/"+empId,
                type:"delete",
                success:function (resp) {
                    alert(resp.msg);
                    to_page(currentPage);
                }
            })
        }
    });

    //完成全选。全不选
    $("#check_all").click(function () {
        //attr获取checked是undefined;
        //我们这些dom原生的属性用prop获取，attr获取定义属性的值
       $(".check_item").prop("checked",$(this).prop("checked"));

       //
    });

    $(document).on("click",".check_item",function () {
        //判断当前选择中的元素是否5个
       var flag=$(".check_item:checked").length==$(".check_item").length;
        $("#check_all").prop("checked",flag);
    });

    //点击全部删除，就批量删除
    $("#emp_delete_all_btn").click(function () {
        //
        var empNames="";
        var del_idstr="";
        $.each( $(".check_item:checked"),function (i,n) {
            empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
            //组装员工id字符串
            del_idstr+=$(this).parents("tr").find("td:eq(1)").text()+"-";
        });
        //去除empNames多余的逗号
        empNames=empNames.substring(0,empNames.length-1);
        //去除员工id多余的"-"
        del_idstr=del_idstr.substring(0,del_idstr.length-1);
        if(confirm("确认删除【"+empNames+"】吗？")){
            //发送ajax请求删除
            $.ajax({
                url:"${APP_PATH}/emp/"+del_idstr,
                type:"delete",
                success:function (resp) {
                    alert(resp.msg);
                    //回到当前页面
                    to_page(currentPage);
                }
            })
        }
    })
</script>

</body>
</html>
