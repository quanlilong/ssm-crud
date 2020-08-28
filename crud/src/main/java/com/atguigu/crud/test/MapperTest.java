package com.atguigu.crud.test;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.util.UUID;

/**测试dao层的工作
 * 使用spring的单元测试，可以自动注入我们需要的组件
 * 1.导入SpringTest模块
 * 2.@ContextConfiguration指定Spring配置文件的位置
 * 3.直接autowire即可
 * @author yzl
 * @create 2020-08-26 18:01
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;
    @Resource
    EmployeeMapper employeeMapper;
    @Autowired
    SqlSession sqlSession;





    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testCRUD(){
//        //1.创建ioc容器
//        ApplicationContext ac=new ClassPathXmlApplicationContext("applicationContext.xml");
//        //2.从容器中获取mapper
//        Department bean = ac.getBean(Department.class);
//        System.out.println(bean);
        System.out.println(departmentMapper);
        //1.插入几个部门

//        departmentMapper.insertSelective(new Department(null, "开发部"));
//        departmentMapper.insertSelective(new Department(null, "测试部"));

        //2.生成员工数据，测试员工插入
//        employeeMapper.insertSelective(new Employee(null,"Jerry","M","Jerry@atguigu.com",1));

        //3.批量插入多个员工,使用可以执行批量操作的sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i=0;i<1000;i++){
            String UID = UUID.randomUUID().toString().substring(0, 5)+i;
            mapper.insertSelective(new Employee(null, UID, "M", UID+"@atguigu.com", 1));
        }
        System.out.println("批量完成");
    }
}
