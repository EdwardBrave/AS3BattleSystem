package{
    import flash.display.Sprite;
    import flash.events.Event;

    public class Main extends Sprite {

        public function Main() {
            if(stage) init();
            else addEventListener(Event.ADDED_TO_STAGE,init);
        }

        //main class intended ONLY for test cases and better if it will never be commit
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // YOUR TEST CASES

        }
    }
}
