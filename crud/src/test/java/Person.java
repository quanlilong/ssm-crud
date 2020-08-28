/**
 * @author yzl
 * @create 2020-08-27 14:07
 */
public class Person {
    private String name;
    private String age;
    public static Person success(){
        Person person = new Person();
        person.setAge("12");
        person.setName("lisi");
        return person;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public static void main(String[] args) {
        Person success = Person.success();
        System.out.println(success);
    }
}
