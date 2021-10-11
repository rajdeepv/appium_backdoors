/*
 * Copyright 2012-2014 eBay Software Foundation, ios-driver and selendroid committers.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 *
 * Copyright 2016-present Mykola Mokhnach at Wire Swiss GmbH
 * Made the Inspector compatible with Appium iOS driver.
 *
 */

Inspector.logLevel = 4; // 0=none, 1=error, 2=error +warning, 3=
// error,warning,info 4 = all


function Inspector(selector) {
    this.busy = false;

    this.lock = false;
    this.log = new Logger(this);
    this.selector = selector;
    this.initAutXml();
}

Inspector.prototype.initScreenshot = function () {
    this.log.info("initScreenshot...");
    $("#screenshot").show();
    const urlParams = new URLSearchParams(window.location.search);
    const screenshot = urlParams.get('screenshot');
    if (screenshot == null)
        $("#screenshot").attr("src", "resources/screenshot.png");
    else
        document.getElementById('screenshot').src = screenshot;
};

Inspector.prototype.transformAutXmlToAjax = function (xmlDoc) {
    var me = this;

    var uuid = function guid() {
        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000)
                .toString(16)
                .substring(1);
        };
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
            s4() + '-' + s4() + s4() + s4();
    };
    var transformNode = function (node) {
        var generatedRef = uuid();
        var toCoordinate = function (strPresentation) {
            if (strPresentation && !!parseFloat(strPresentation)) {
                return Math.round(parseFloat(strPresentation));
            } else {
                return 0;
            }
        };
        var toPrettyNodeName = function (node) {
            if (!!node.getAttribute("name")) {
                return "[" + node.nodeName + " :: " + node.getAttribute("name") + "]";
            } else {
                return "[" + node.nodeName + "]";
            }
        };
        var bounds = node.getAttribute("bounds");
        bounds = bounds.split(/\[|\]|,/).filter(function (el) {
            return el;
        });
        var x = bounds[0];
        var y = bounds[1];
        var width = bounds[2] - x;
        var height = bounds[3] - y;
        me.log.info(bounds.length);
        var nodeAsJson = {
            "data": toPrettyNodeName(node),
            "id": toPrettyNodeName(node),
            "attr": {
                "id": generatedRef
            },
            "metadata": {
                "type": node.nodeName,
                "reference": generatedRef,
                "id": node.getAttribute("resource-id"),
                "text": node.getAttribute("text"),
                "pkg": node.getAttribute("package"),
                "contentDesc": node.getAttribute("content-desc"),
                "viewTag": node.getAttribute("view-tag"),
                "value": node.getAttribute("value"),
                "checked": node.getAttribute("checked"),
                "enabled": node.getAttribute("enabled"),
                "selected": node.getAttribute("selected"),
                "focused": node.getAttribute("focused"),
                "l10n": {
                    "matches": 0
                },
                "shown": node.getAttribute("visible") || node.getAttribute("shown"),
                "source": "",
                "error": "",
                "rect": {
                    "x": toCoordinate(x),
                    "y": toCoordinate(y),
                    "h": toCoordinate(height),
                    "w": toCoordinate(width)
                },
            },
            "children": new Array()
        };
        node.setAttribute("ref", generatedRef);
        return nodeAsJson;
    };
    var traverseDocument = function traverser(root) {
        var res = transformNode(root);
        if (root.hasChildNodes()) {
            for (var i = 0; i < root.childNodes.length; i++) {
                // Only nodes of type Element are counted
                if (root.childNodes[i].nodeType == 1) {
                    res.children.push(traverser(root.childNodes[i]));
                }
            }
        }
        return res;
    };
    var result = traverseDocument(xmlDoc.documentElement);
    var oSerializer = new XMLSerializer();
    result.metadata.xml = oSerializer.serializeToString(xmlDoc);
    return result;
};

Inspector.prototype.initAutXml = function () {
    var me = this;
    var msStarted = performance.now();
    this.log.info("initAutXml...");
    $("#screenshot").hide();
    $("#tree").hide();
    $("#loadingTree").show();
    const urlParams = new URLSearchParams(window.location.search);
    const xml = urlParams.get('xml');
    var resource = xml == null ? 'resources/tree.xml' : xml;
    $.get(resource, function (data) {
        me.initScreenshot();

        $("#screenshot").on('load', window.resize);
        $("#loadingTree").hide();
        $("#tree").show();
        var jsTreeData = me.transformAutXmlToAjax(data);
        me.jsTreeConfig = {
            "core": {
                "animation": 0,
                "load_open": true
            },
            "json_data": {
                "data": jsTreeData
            },
            "themes": {
                "theme": "apple"
            },
            "plugins": ["themes", "json_data", "ui"]
        };

        me.init();
    });
};

Inspector.prototype.reloadData = function () {
    var me = this;
    me.jstree = $(me.selector).jstree(me.jsTreeConfig);
    me.jstree.bind("loaded.jstree", function (event, data) {
        me.onTreeLoaded(event, data);
    });
    me.jstree.bind("hover_node.jstree", function (event, data) {
        me.onNodeMouseOver(event, data);
    });

};

/**
 *
 * @param selector
 *            {string} jquery selector of the element that will host the jsTree.
 */
Inspector.prototype.init = function () {
    var me = this;

    this.reloadData();

    $("#mouseOver").mousemove(function (event) {
        me.onMouseMove(event);
    });
    $("#mouseOver").click(function (event) {
        me.onMouseClick(event);
    });

    $(document).keydown(function (e) {
        var ESC_KEY = 27;
        if (e.ctrlKey) {
            me.toggleLock();
        } else if (e.keyCode === ESC_KEY) {
            me.toggleXPath();
        }
    });

    me.toggleXPath(false);

    $('#xpathInput').keyup(function () {
        var xpath = $(this).val();

        try {
            var elements = me.findElementsByXpath2(xpath);
            me.select(elements);
            $('#xpathLog').html("found " + elements.length + " results.");
        } catch (err) {
            me.unselect();
            $('#xpathLog').html("Error: " + err.message);
        }
    });

}

/**
 * select the list of elements.Elements are XML nodes from a xpath query.
 *
 * @param elements
 */
Inspector.prototype.select = function (elements) {
    this.unselect();
    for (var i = 0; i < elements.length; i++) {
        var element = elements[i];
        if (element.getAttributeNode("ref")) {
            var ref = element.getAttributeNode("ref").nodeValue;
            var node = new NodeFinder(this.root).getNodeByReference(ref);
            this.selectOne(node, elements.length === 1);
        }
    }
}

/**
 * mouse over the object tree.
 *
 * @param e
 * @param data
 */
Inspector.prototype.onNodeMouseOver = function (e, data) {
    if (!this.lock) {
        this.unselect();
        this.selectOne(data, true);
    }
}

/**
 * init all variable when the tree is done loading.
 *
 * @param event
 * @param data
 */
Inspector.prototype.onTreeLoaded = function (event, data) {
    try {
        this.root = this.jstree.jstree('get_json')[0];
        this.xml = this.root.metadata.xml;

        var webView = this.extractWebView(this.getRootNode());
        if (webView != null) {
            setHTMLSource(webView.metadata.source);
        } else {
            setHTMLSource(null);
        }
        this.expandTree();
        this.loadXpathContext();

        this.busy = false;
        resize();
    } catch (err) {
        console.log("Initialization failed", err);
    }
}

/**
 * unselect everything. Highlight on the device, the tree, and the optional
 * details.
 */
Inspector.prototype.unselect = function () {
    $('#details').html("");
    $('#xpathLog').html("");
    $('#htmlSource').html("");
    this.jstree.jstree('deselect_all');
    this.highlight();
}

/**
 * Select the specified node. Node is a node from jstree.
 *
 * @param node
 * @param displayDetails
 *            {boolean} true will display the info in the right column. If more
 *            than one node is displayed, the node details will overwrite each
 *            other.
 */
Inspector.prototype.selectOne = function (node, displayDetails) {
    var rect;
    var type;
    var ref;
    var id;
    var text;
    var pkg;
    var contentDesc;
    var viewTag;
    var value;
    var visible;
    var checked;
    var enabled;
    var selected;
    var focused;
    var l10n;
    var source;

    if (node.metadata) {// from tree parsing, json node
        rect = node.metadata.rect;
        type = node.metadata.type;
        ref = node.metadata.reference;
        id = node.metadata.id;
        text = node.metadata.text;
        pkg = node.metadata.pkg;
        value = node.metadata.value;
        contentDesc = node.metadata.contentDesc;
        viewTag = node.metadata.viewTag;
        visible = node.metadata.shown;
        checked = node.metadata.checked;
        enabled = node.metadata.enabled;
        selected = node.metadata.selected;
        focused = node.metadata.focused;
        l10n = node.metadata.l10n;
        source = node.metadata.source;
    } else {// from listener, jstree node
        rect = node.rslt.obj.data("rect");
        type = node.rslt.obj.data('type');
        ref = node.rslt.obj.data('reference');
        id = node.rslt.obj.data('id');
        text = node.rslt.obj.data('text');
        pkg = node.rslt.obj.data('pkg');
        value = node.rslt.obj.data('value');
        contentDesc = node.rslt.obj.data('contentDesc');
        viewTag = node.rslt.obj.data('viewTag');
        visible = node.rslt.obj.data('shown');
        checked = node.rslt.obj.data('checked');
        enabled = node.rslt.obj.data('enabled');
        selected = node.rslt.obj.data('selected');
        focused = node.rslt.obj.data('focused');
        l10n = node.rslt.obj.data('l10n');
        source = node.rslt.obj.data('source');
    }

    if (rect === undefined) {
        return;
    }

    this.jstree.jstree('select_node', '#' + ref);
    var translationFound = false;
    if (l10n) {
        translationFound = (l10n.matches != 0);
    }

    this.highlight(rect.x, rect.y, rect.h, rect.w, translationFound, ref);
    if (displayDetails) {
        this.showDetails(type, ref, id, text, pkg, value, contentDesc, viewTag, visible, checked, enabled, selected, focused, rect, l10n, source);
        this.showActions(type, ref);
    }

}

Inspector.prototype.calculateAbsoluteNodePath = function (ref) {
    var getIndex = function (node) {
        if (node.parentNode) {
            var children = node.parentNode.childNodes;
            var elementIndex = 1;
            for (var i = 0; i < children.length; i++) {
                var child = children[i];
                if (child.nodeType == 1) {
                    if (child.getAttributeNode("ref") && child.getAttributeNode("ref").nodeValue === node.getAttributeNode("ref").nodeValue) {
                        return elementIndex;
                    } else if (child.nodeName === node.nodeName) {
                        elementIndex++;
                    }
                }
            }
        }
        return 1;
    }
    var currentNodes = this.findElementsByXpath2("//*[@ref='" + ref + "']");
    var result = "";
    if (currentNodes && currentNodes.length > 0) {
        var currentNode = currentNodes[0];
        while (currentNode.parentNode) {
            var index = getIndex(currentNode);
            result = "/" + currentNode.nodeName + ((index == 1) ? "" : "[" + index + "]") + result;
            currentNode = currentNode.parentNode;
        }
    }
    if (result.length > 0) {
        return result;
    } else {
        return "N/A";
    }
}

/**
 * show the info about a node in the right details section.
 *
 * @param type
 * @param ref
 * @param id
 * @param text
 * @param pkg
 * @param isVisible
 * @param isChecked
 * @param isEnabled
 * @param isSelected
 * @param isFocused
 * @param html
 */
Inspector.prototype.showDetails = function (type, ref, id, text, pkg, value, contentDesc, viewTag, isVisible, isChecked, isEnabled, isSelected, isFocused, rect, l10n, html) {
    var me = this;
    $('#details').html(
        "<h3>Details</h3>" + "<p><b>Class: </b>" + type + "</p>"
        + "<p><b>Id: </b>" + id + "</p>"
        + "<p><b>Text: </b>" + text + "</p>"
        + "<p><b>content-desc: </b>" + contentDesc + "</p>"
        + "<p><b>view-tag: </b>" + viewTag + "</p>"
        + "<p><b>Checked: </b>" + isChecked + "</p>"
        + "<p><b>Enabled: </b>" + isEnabled + "</p>"
        + "<p><b>Selected: </b>" + isSelected + "</p>"
        + "<p><b>Focused: </b>" + isFocused + "</p>"
        + "<p><b>Rect: </b>x=" + rect.x + ", y=" + rect.y + ", h=" + rect.h + ", w=" + rect.w + "</p>"
        + "<p><b>Value: </b>" + value + "</p>"
        + "<p><b>Visible: </b>" + isVisible + "</p>"
        + "<p><b>Absolute XPath(can be used to check with driver.find_element): </b>"
        + "<br><input id='absoluteXPath' style='width: 95%;' onclick='this.focus();this.select()' readonly='readonly'></input></p>");

    $('#absoluteXPath').val(me.calculateAbsoluteNodePath(ref));

    var content = $('#htmlSource').html() + "\n" + html;

    this.log.debug(content);
    $('#htmlSource').html(content.escape());
    if (prettyPrint) {
        prettyPrint();
    }
};

/**
 * Escapes the html
 * @returns {string}
 */
String.prototype.escape = function () {
    var tagsToReplace = {'&': '&amp;', '<': '&lt;', '>': '&gt;'};
    return this.replace(/[&<>]/g, function (tag) {
        return tagsToReplace[tag] || tag;
    });
};

/**
 * Highlight an area on the device.
 *
 * @param x
 * @param y
 * @param h
 * @param w
 * @param translationFound
 * @param ref
 */
Inspector.prototype.highlight = function (x, y, h, w, translationFound, ref) {
    if (typeof x != 'undefined') {
        var d = $("<div></div>", {
            "class": "hightlight"
        });
        d.appendTo("#rotationCenter");

        var retinaScale = 1;

        d.css('border', "1px solid red");
        d.css('left', x * scale_highlight * retinaScale + realOffsetX + 'px');
        d.css('top', y * scale_highlight * retinaScale + realOffsetY + 'px');
        d.css('height', h * scale_highlight * retinaScale + 'px');
        d.css('width', w * scale_highlight * retinaScale + 'px');
        // d.css('left', x + realOffsetX + 'px');
        // d.css('top', y + realOffsetY + 'px');
        // d.css('height', h + 'px');
        // d.css('width', w + 'px');
        d.css('position', 'absolute');
        d.css('background-color', 'yellow');
        d.css('z-index', '3');
        d.css('opacity', '0.5');
        d.css('opacity', '0.5');
        var color;
        if (translationFound) {
            color = "blue";
        } else {
            color = "yellow";
        }
        d.css("background-color", color);

    } else {
        $(".hightlight").remove();
    }

}

Inspector.prototype.showActions = function (type, ref) {
    // check action per type.
    $('#reference').html(
        "<input type='hidden' name='reference' value='" + ref + "'>");
}

Inspector.prototype.getRootNode = function () {
    if (this.root) {
        return this.root;
    } else {
        throw new Error(
            'Cannot access the root node. The tree is not fully loaded');
    }

}
Inspector.prototype.expandTree = function () {
    this.jstree.jstree("open_all");
}

Inspector.prototype.extractWebView = function (node) {
    var type = node.metadata.type;
    if ("WebView" === type) {
        return node;
    } else {
        var children = node.children;
        if (children) {
            for (var i = 0; i < children.length; i++) {
                var child = children[i];
                var res = this.extractWebView(child);
                if (res) {
                    return res;
                }
            }
        }

    }
    return null;
}

Inspector.prototype.getTreeAsXMLString = function () {
    if (this.xml) {
        return this.xml;
    } else {
        throw new Error(
            'Cannot get the xml for that tree.The tree is not fully loaded');
    }
};

Inspector.prototype.parseXml = function (xmlStr) {
    if (window.DOMParser) {
        return (new window.DOMParser()).parseFromString(xmlStr, "text/xml");
    } else if ("undefined" !== typeof window.ActiveXObject && new window.ActiveXObject("Microsoft.XMLDOM")) {
        var xmlDoc = new window.ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = "false";
        xmlDoc.loadXML(xmlStr);
        return xmlDoc;
    }
    return null;
}

/**
 * init the xpath search content from the XML raw string.
 */
Inspector.prototype.loadXpathContext = function () {
    var xmlObject = this.parseXml(this.getTreeAsXMLString());
    this.xpathContext = xmlObject.ownerDocument == null ? xmlObject.documentElement
        : xmlObject.ownerDocument.documentElement;
}

/**
 * find elements by xpath.
 *
 * @param xpath
 * @return {array} of elements.
 * @throws Error
 *             if the xpath is invalid.
 */
Inspector.prototype.findElementsByXpath2 = function (xpath) {
    var res = $(this.xpathContext).xpath(xpath);
    return res;
}

/**
 * mouse move for the device mouse over.
 *
 * @param event
 */
Inspector.prototype.onMouseMove = function (event) {

    if (!this.lock) {
        var retinaScale = 1;

        var parentOffset = $("#mouseOver").offset();
        var x = event.pageX - parentOffset.left;
        var y = event.pageY - parentOffset.top;
        x = x / scale_highlight / retinaScale;
        y = y / scale_highlight / retinaScale;
        console.log(x + "," + y);
        var finder = new NodeFinder(this.root);
        var node = finder.getNodeByPosition(x, y);
        if (node) {
            this.unselect();
            this.selectOne(node, true);
        } else {
            console.log('couldn t find element at ' + x + ' , ' + y);
        }
    }
}

/**
 * mouse move for the device mouse over.
 *
 * @param event
 */
Inspector.prototype.onMouseClick = function (event) {

    console.log("Is busy " + this.busy);
}


/**
 * toggle the lock mode for the page. Mouse over are disabled when the page is
 * locked.
 */
Inspector.prototype.toggleLock = function () {
    this.lock = !this.lock;
}

/**
 * toggle the Xpath overlay.
 *
 * @param force
 */
Inspector.prototype.toggleXPath = function (force) {
    var show = false;
    if (typeof force != 'undefined') {
        show = force;
        this.xpathMode = show;
    } else {
        show = !this.xpathMode;
    }

    if (show) {
        this.xpathMode = true;

        $("#xpathHelper").dialog({
            resizable: false,
            minWidth: 600,
            dialogClass: "no-close"
        });
        $("#xpathHelper").show();
        $("#xpathInput").focus();
    } else {
        this.xpathMode = false;
        $("#xpathHelper").hide();
        $("#xpathInput").blur();
    }
}

function NodeFinder(rootNode) {

    this.matchScore = -1;
    this.candidate = null;

    this.rootNode = rootNode;

    this._hasCorrectPosition = function (node, x, y) {
        var currentX = node.metadata.rect.x;
        var currentY = node.metadata.rect.y;
        var currentH = node.metadata.rect.h;
        var currentW = node.metadata.rect.w;

        if ((currentX <= x) && (x <= (currentX + currentW))) {
            if ((currentY <= y) && (y <= (currentY + currentH))) {
                return true;
            }
        }
        return false;
    };

    this._assignIfBetterCandidate = function (newNode, x, y) {
        if (this._hasCorrectPosition(newNode, x, y)) {
            var surface = (newNode.metadata.rect.h * newNode.metadata.rect.w);
            if (this.candidate) {
                if (surface < this.matchScore) {
                    this.matchScore = surface;
                    this.candidate = newNode;
                }
            } else {
                this.matchScore = surface;
                this.candidate = newNode;
            }
        }
    };

    this.getNodeByPosition = function (x, y) {
        this._getCandidate(this.rootNode, x, y);
        return this.candidate;
    };

    this.getNodeByReference = function (ref) {
        return this._getNodeByReference(this.rootNode, ref);
    }

    this._getNodeByReference = function (node, ref) {
        var reference = node.metadata.reference;
        if (reference === ref) {
            return node;
        } else {
            if (node.children) {
                for (var i = 0; i < node.children.length; i++) {
                    var child = node.children[i];
                    var correctOne = this._getNodeByReference(child, ref);
                    if (correctOne) {
                        return correctOne;
                    }

                }
            }
        }

    }

    this._getCandidate = function (from, x, y) {
        this._assignIfBetterCandidate(from, x, y);
        if (from.children) {
            for (var i = 0; i < from.children.length; i++) {
                var child = from.children[i];
                this._getCandidate(child, x, y);
            }
        }
    };
}
