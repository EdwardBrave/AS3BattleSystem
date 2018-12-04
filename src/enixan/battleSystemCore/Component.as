package enixan.battleSystemCore {

    /**
     *  Base class for logic what is contain only one behaviour
     * */
    public class Component implements IComponent {

        private var _process:Process;

        private var _container:Container;

        public function get process():Process {
            return _process;
        }

        public function get container():Container {
            return _container;
        }

        public function set container(parent:Container):void {
            _container = parent;

        }


        public function Component() {
            _process = new Process(0);
        }

        public function toString():String {
            return "Component";
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
