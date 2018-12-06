package enixan.battleSystemCore {
        import flash.utils.getQualifiedClassName;

    /**
     *  Base class of logic that is contain only one behaviour
     * */
    public class Component implements IComponent {

        private var _process:Process;

        protected var _container:Container;

        public function get process():Process {
            return _process;
        }

        public function get container():Container {
            return _container;
        }

        public function set container(parent:Container):void {
            _container = parent;
        }


        public function Component(priority:uint = int.MAX_VALUE) {
            _process = new Process(priority);
        }


        public function toString():String {
            var className:String = getQualifiedClassName(this);
            className = className.substr(className.lastIndexOf(":")+1);
            return className;
        }

        public function init(settings:Object):void {

        }

        public function start():void {

        }

        public function refreshSettings(settings:Object):void {

        }

        public function update():void {

        }


        public function destruct():void {
            _process.kill();
            _container = null;
        }
    }
}
