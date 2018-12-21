package hlp {

    /**
     * Class manage vectors by keys and its elements that stored in sorted list structure
     * @author EdwardBrave
     * */
    public class List {

        /** Key of current node of List */
        private var _key:uint;

        /** Vector of values of current node of List */
        private var _items:Vector.<Object>;

        /** Pointer of current node of List */
        private var _nextItem:List;

        /**
         *  Construct the node of list
         *  @param key Base value that define the lower limit of the list
         *  @param value Object that will be put in the vector. if its **null** then vector will be empty
         * */
        public function List(key:uint = 0, value:Object = null) {
            _key = key; 
            _items = new Vector.<Object>();
            if (value) {
                _items.push(value);
            }
        }

        /**
         *  Enumerate all items of vectors of all nodes by queue *(from lesser to bigger)*
         *  @param eacher Base value that define the lower limit of the list
         * */
        public function forEach(eacher:Function):void {
            if (_items) {
                for each(var item:Object in _items){
                    if (item) eacher(item);
                }
            }
            if (_nextItem) {
                _nextItem.forEach(eacher);
            }
        }

        /**
         *  Add new object to specific node vector by given key or create new node for it
         *  @param key Index of node where value will be add. It must be equal or more than basic key value or it will be ignored
         *  @param value Object that will be put in the vector. if its **null** than function will ignore it
         * */
        public function push(key:uint, value:Object):void {
            if (!value) return;
            if (key == _key) {
                if(_items.indexOf(value) == -1) {
                    _items.push(value);
                }
            }else if (!_nextItem) {
                _nextItem = new List(key, value);
            }else if (key >= _nextItem._key) {
                _nextItem.push(key, value);
            }else{
                var middleItem:List = new List(key, value);
                middleItem._nextItem = _nextItem;
                _nextItem = middleItem;
            }
        }

        /**
         *  Make new list of nodes that contain of sorted each other current list and new one
         *  @param list List of nodes that you wont to add to current. If its **null** then function return **this**
         *  @return New sorted list of all nodes of given lists
         * */
        public function concat(list:List):List {
            if (!list) return this;
            var multiList:List = new List();
            for each(var currentList:List in [list,this]) {
                while (currentList) {
                    for each(var item:* in currentList._items) {
                        multiList.push(currentList._key, item);
                    }
                    currentList = currentList._nextItem;
                }
            }
            return multiList;
        }

        /**
         *  Search and remove given object only of given node by key
         *  @param key Index of node from which vector`s value will be deleted
         *  @param value Object that will be deleted from the vector
         * */
        public function removeItemAt(key:uint, value:Object):void {
            if (key == _key){
                var index:int = _items.indexOf(value);
                if(index != -1) {
                    _items.removeAt(index);
                }
            }else if (_nextItem) {
                _nextItem.removeItemAt(key, value);
                if (!_nextItem._items.length) {
                    removeNode(_nextItem._key);
                }
            }
        }

        /**
         *  Search vector of objects by given key of node
         *  @param key Index of vector in current list
         *  @return Vector of objects or null if it doesn't exist
         * */
        public function getVector(key:uint):Vector.<Object> {
            if (key == _key) {
                return _items;
            } else if (_nextItem) {
                return _nextItem.getVector(key);
            }
            return null;

        }

        /**
         *  Search and remove given object in the first found node that contains it.
         *  if vector of node become empty then this node will be removed
         *  @param value Object that will be deleted from the vector
         * */
        public function removeItem(value:Object):void {
            var index:int = _items.indexOf(value);
            if(index != -1) {
                _items.removeAt(index);
            }else if (_nextItem) {
                _nextItem.removeItem(value);
                if (!_nextItem._items.length) {
                    removeNode(_nextItem._key);
                }
            }
        }

        /**
         *  Search and remove whole node by given key and manage pointers architecture after it.
         *  if vector of node become empty then this node will be removed
         *  @param key Index of node that will be deleted
         * */
        public function removeNode(key:uint):void {
            if (!_nextItem) return;
            if (_nextItem._key == key) {
                _nextItem = _nextItem._nextItem;
            }else{
                _nextItem.removeNode(key);
            }
        }

        /**
         * Clear and remove all nodes in current list
         */
        public function clear():void{
            _items.splice(0, _items.length);
            if(_nextItem) {
                _nextItem.clear();
            }
            _nextItem = null;
        }
    }
}
