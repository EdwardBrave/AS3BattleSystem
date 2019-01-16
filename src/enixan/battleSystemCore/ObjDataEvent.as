package enixan.battleSystemCore {
    import flash.events.Event;

    /**
     * Class store a *data* of current event that can be dispatch to others
     * */
    public class ObjDataEvent extends Event {

        /**Event of default data sending*/
        public static const DATA_EVENT:String = "objectDataEvent";

        /**Object with some sended data by event*/
        public var data:Object;

        /**
         * Class store a *status* of current event that can be used after dispatch
         * This functionality using in the **Behaviour Tree** pattern
         * @param _type go to parent for details
         * @param bubbles go to parent for details
         * @param cancelable go to parent for details
         * @param data additional information that can be add to event
         * */
        public function ObjDataEvent(_type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:Object = null) {
            super(_type, bubbles, cancelable);
            this.data = data;
        }
    }
}
