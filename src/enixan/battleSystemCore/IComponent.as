package enixan.battleSystemCore {

    /**
     * Interface for all components, that can be connected to Container and Entity respectively
     * */
    public interface IComponent {

        /**
         * Must give a pointer on the **Process** of **Component** or **null** if it doesnt support
         * @return pointer on the **Process**
         * */
        function get process():Process;

        /**
         * Must give a pointer on parent **Container** or **null** if it still undefined
         * @return pointer on parent **Container**
         * */
        function get container():Container;

        /**
         * Must take a pointer on parent **Container** and initialize methods and params associated with it
         * @return pointer on parent **Container**
         * */
        function set container(parent:Container):void;

        /**
         * Must give the name of **Component** for *BehaviourManager* logic
         * @return name on **Component**
         * */
        function toString():String;

        /**
         * Must take the settings and initialize component with them
         * @param settings Values that allows to customise component logic
         * */
        function init(settings:Object):void;

        /**
         * Function that reacts on start battle event
         * */
        function start():void;

        /**
         * Must take the settings and refresh *(change)* logic of **Component** with them
         * @param settings Values that allows to customise component logic
         * */
        function refreshSettings(settings:Object):void;

        /**
         * Function that reacts on every update event of battle
         * */
        function update():void;

        /**
         * Must remove the **Component** and all information about it
         * **CAUTION!** After this action the **Component** will be dead and unusable
         * */
        function destruct():void;
    }
}
