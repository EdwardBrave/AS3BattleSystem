package enixan.battleSystemCore {
        import flash.utils.getQualifiedClassName;

    /**
     *  Base class of logic that is contain only one behaviour
     * */
    public class Component implements IComponent {

        /**The pointer on the **Process***/
        private var _process:Process;

        /**Pointer on parent container*/
        protected var _container:Container;

        /**Object of settings for customisation of work logic*/
        protected var _settings:Object;

        /**
         * Give a pointer on the **Process** of **Component** or **null** if it doesnt support
         * @return pointer on the **Process**
         * */
        public function get process():Process {
            return _process;
        }

        /**
         * Give a pointer on parent **Container** or **null** if it still undefined
         * @return pointer on parent **Container**
         * */
        public function get container():Container {
            return _container;
        }

        /**
         * Take a pointer on parent **Container** and initialize methods and params associated with it
         * @param parent Pointer on parent **Container**
         * */
        public function set container(parent:Container):void {
            _container = parent;
        }

        /**
        * Constructor of component that initialize single behaviour logic
        * @param priority Value of place of the Process in global update queue
        * @param settings Values that allows to customise component logic
        * */
        public function Component(priority:uint = int.MAX_VALUE, settings:Object = null) {
            _settings = {};
            _process = new Process(priority);
            if (settings) {
                init(settings);
            }
        }

        /**
         * Give the name of current child of **Component**
         * @return name of **Component**
         * */
        final public function toString():String {
            var className:String = getQualifiedClassName(this);
            className = className.substr(className.lastIndexOf(":")+1);
            return className;
        }

        /**
         * Must take the settings and initialize component with them
         * *You should override this function for use*
         * @param settings Values that allows to customise component logic
         * */
        public function init(settings:Object):void {
            refreshSettings(settings);
        }

        /**
         * Function that reacts on start battle event
         * *You should override this function for use*
         * */
        public function start():void {}

        /**
         * Must take the settings and refresh *(change)* logic of **Component** with them
         * *You should override this function for use*
         * @param settings Values that allows to customise component logic
         * */
        public function refreshSettings(settings:Object):void {
            if (settings) {
                for (var val:String in settings) {
                    _settings[val] = settings[val];
                }
            }
        }

        /**
         * Function that reacts on every update event of battle
         * *You should override this function for use*
         * */
        public function update():void {}

        /**
         * Remove the **Component** and all information about it
         * **CAUTION!** After this action the **Component** will be dead and unusable
         * */
        public function destruct():void {
            _process.kill();
            _container = null;
        }
    }
}
