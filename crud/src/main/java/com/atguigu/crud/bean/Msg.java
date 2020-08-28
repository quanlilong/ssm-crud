package com.atguigu.crud.bean;

import com.github.pagehelper.PageInfo;

import java.util.HashMap;
import java.util.Map;

/**通用的返回json数据的类
 * @author yzl
 * @create 2020-08-27 14:01
 */
public class Msg {

    private int code;//状态码 100-成功 200-失败
    private String msg;//提示信息
    //用户要返回给浏览器的数据
    private Map<String,Object> extend=new HashMap<>();
    public static Msg success(){
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功！");
        return result;

    }
    public static Msg fail(){
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败！");
        return result;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

    public Msg add(String key, Object value) {
        this.getExtend().put(key, value);//链式编程,return this;
        return this;
    }
}
