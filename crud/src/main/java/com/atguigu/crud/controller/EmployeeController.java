package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**处理crud请求
 * @author yzl
 * @create 2020-08-26 20:10
 */
@Controller
public class EmployeeController {
    @Resource
    private EmployeeService employeeService;

    /**
     * 单个删除和批量删除合一
     * 批量删除1-2-3
     * 单个删除：1
     * @param ids
     * @return
     */
   @RequestMapping(value="/emp/{ids}",method = RequestMethod.DELETE)
   @ResponseBody
   public Msg deleteEmpById(@PathVariable("ids") String ids){
       if(ids.contains("-")){
           String[] str_ids = ids.split("-");
           List<Integer> del_ids=new ArrayList<>();
           //组装id的集合
           for (String str_id : str_ids) {
               del_ids.add(Integer.parseInt(str_id));
           }
            employeeService.deleteBatch(del_ids);
       }else{
           Integer id = Integer.parseInt(ids);
           employeeService.deleteEmp(id);
       }

        return Msg.success();
   }

    /**
     * 员工更新方法
     * @param employee
     * @return
     */
    @RequestMapping(value="/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee){
        System.out.println("将要更新的员工数据："+employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 根据id查询员工
     * @param id
     * @return
     */
    @RequestMapping(value="/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){//@PathVariable("id")指定方法接收的id参数来自请求路径
        Employee employee=employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }

    /**
     * 后端springmvc校验
     * 1.支持JSR303校验
     * 2.导入Hibernate-Validator
     */

    /**
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkUser")
    public Msg checkUser(String empName){
        //先判读用户是否是合法的表达式
        String regx="(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        boolean res = empName.matches(regx);//String方法里的matches()匹配正则表达式
        if(!res){
            return Msg.fail().add("va_msg", "用户名必须是6-16位数字和字母的组合或者2-5位中文");
        }
        //数据库用户名重复校验
        boolean b=employeeService.checkUser(empName);
        if(b){
            return Msg.success();
        }else{
            return Msg.fail().add("va_msg", "用户名不可用");
        }
    }


    /**
     * 员工保存
     * @return
     */
    @RequestMapping(value="/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            //校验失败，返回失败，在模块框中显示校验失败的错误信息
            Map<String,Object> map=new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                System.out.println("错误的字段名："+fieldError.getField());
                System.out.println("错误信息："+fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }

    }




    //使用ajax方法返回json数据，自定义个Msg类返回
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
        //引入PageHelper插件
        //在查询之前只需要调用PageHelper.startPage(页码，每页的数目),
        PageHelper.startPage(pn, 5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps= employeeService.getAll();
        //使用PageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
        //封装了详细的分页信息，包括有我们查询出来的数据;传入连续显示的页数
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",pageInfo);//链式编程
    }

    /**
     * 查询员工数据（分页查询），没有使用ajax
     * @return
     */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
        //引入PageHelper插件
        //在查询之前只需要调用PageHelper.startPage(页码，每页的数目),
        PageHelper.startPage(pn, 5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps= employeeService.getAll();
        //使用PageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
        //封装了详细的分页信息，包括有我们查询出来的数据;传入连续显示的页数
        PageInfo pageInfo = new PageInfo(emps,5);
        model.addAttribute("pageInfo", pageInfo);
        return "list";
    }

}
