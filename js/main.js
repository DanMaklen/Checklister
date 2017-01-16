var tree = [];
var treeName = "DarkSoulsPTDE";
var checklist;

$(document).ready(function(){
	checklist = $("#checklist").treeview({
		data: tree[treeName],
		enableLinks: true,
		showCheckbox: true,
		onNodeChecked: function(e, node){
			var cur = node;
			while((cur = checklist.getParent(cur)) && !cur.state.checked){
				if(cur.nodes.length == ++cur.child_check_count)
					checklist.checkNode(cur, {silent: true});
				else break;
			}
			if(node.nodes != undefined){
				var children = node.nodes;
				node.child_check_count = children.length;
				for(var i = 0; i < children.length; i++)
					if(!children[i].state.checked)
						checklist.checkNode(children[i].nodeId);
			}
		},
		onNodeUnchecked: function(e, node){
			var cur = node;
			while((cur = checklist.getParent(cur)) && cur.state.checked){
				cur.child_check_count--;
				checklist.uncheckNode(cur, {silent: true});
			}
			if(node.nodes != undefined){
				var children = node.nodes;
				node.child_check_count = 0;
				for(var i = 0; i < children.length; i++)
					if(children[i].state.checked)
						checklist.uncheckNode(children[i].nodeId);
			}
		},
	}).treeview(true);

	loadTreeState();
});

$(window).on("unload", function() {
	storeTreeState();
});


function storeTreeState(){
	var Nodes = checklist.getEnabled();
	var treeState = {
		checked: [],
		expanded: []
	};
	for(var i = 0; i < Nodes.length; i++){
		if(Nodes[i].state.checked) treeState.checked.push(Nodes[i].nodeId);
		if(Nodes[i].state.expanded) treeState.expanded.push(Nodes[i].nodeId);
	}
	localStorage[treeName] = JSON.stringify(treeState);
}
function loadTreeState(){
	var raw = localStorage[treeName];
	if(raw == undefined) return;
	var treeState = JSON.parse(localStorage[treeName]);

	checklist.uncheckAll({silent: true});
	checklist.collapseAll({silent: true});
	checklist.checkNode(treeState.checked);
	checklist.expandNode(treeState.expanded, {silent: true});
}
