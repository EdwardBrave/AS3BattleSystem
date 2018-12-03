package enixan.battleSystemCore {

    /**
     *  Base class for logic what is contain only one behaviour
     * */
    public class Component implements IComponent {

        private var _container:Container;

        public function get container():Container {
            return _container;
        }

        public function set container(parent:Container):void {
            _container = parent;
        }

        public function Component() {

        }

        public function toString():String{
            return "Component";
        }

        public function destruct():void{
            _container = null;
        }
    }
}
