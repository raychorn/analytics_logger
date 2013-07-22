Ext.analyticsAdmin = function(){
	return {
		init: function(){
			// main center panel displays server logs
			var serverPanel = new Ext.ux.ManagedIFrame.Panel({ autoLoad:{url:'admin/servers.html',height:'100%',width:'100%', text: 'Loading...' },
			    title: 'Server Logs',
			    collapsible: false,
			    region:'center',
				loadMask :false,
			});
			// left nav tree for servers
			var navTree = new Ext.tree.TreePanel({
				title: 'Logging Servers',
				region: 'west',
				width: 200,
				rootVisible: false,
				collapsible:true,
				dataUrl: 'admin/servers.json',
				requestMethod:'GET',
				root: {
					nodeType: 'async',
					text: 'Logging Servers',
					draggable: false,
					id: 'servers',
					expanded: true
				},
				listeners: {
		            click: function(n) {
						if (n.isLeaf()) {
							serverPanel.setSrc(n.attributes.data.server_url);
						}
		            }
		        }				
			});
			// main viewport holding the various panels
			var viewport = new Ext.Viewport({
				layout: 'border',
				items: [
					navTree,
					serverPanel
				]
			});
			navTree
		}
	};
}();