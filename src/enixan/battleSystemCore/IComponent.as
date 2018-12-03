package enixan.battleSystemCore {

    /**
     * Interface for all components, that can be connected to Container and Entity respectively
     * */
    public interface IComponent {

        function toString():String;

        function get container():Container;

        function set container(parent:Container):void;

        function destruct():void;
    }
}
