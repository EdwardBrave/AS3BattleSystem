package enixan.battleSystemCore {

    /**
     * Interface for BehaviourManager manager, that must to control components activity in its environment
     * */
    public interface IBehaviourManager {

        /**
         * Must give a pointer on parent **Entity** or **null** if it still undefined
         * @return pointer on parent **Entity**
         * */
        function get container():Entity;

        /**
         * Must take a pointer on parent **Entity** and initialize methods and params associated with it
         * @return pointer on parent **Entity**
         * */
        function set container(parent:Entity):void;

        /**
         * Function that reacts on start battle event
         * */
        function start():void;

        /**
         * Must take the settings and refresh *(change)* logic of **BehaviourManager** with them
         * @param settings Values that allows to customise component logic
         * */
        function refreshSettings(settings:Object):void;

        /**
         * Function that reacts on every update event of battle and manage components of **Entity**
         * */
        function update():void;

        /**
         * Must remove the **BehaviourManager** and all information about it
         * **CAUTION!** After this action the **BehaviourManager** will be dead and unusable
         * */
        function destruct():void;
    }
}
