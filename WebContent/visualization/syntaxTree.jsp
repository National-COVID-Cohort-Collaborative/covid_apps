<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<div id="tree" style=" float:left; width:100px">
<style> 
    
.node circle {
  fill: #fff;
  stroke: #037C93;
  stroke-width: 2px;
}

.node text { font: 12px sans-serif; }

.node--internal text {
  text-shadow: 0 1px 0 #fff, 0 -1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff;
}

.link {
  fill: none;
  stroke: #ccc;
  stroke-width: 2px;
}

</style>

<div id="option">
    <input name="updateButton" 
           type="button" 
           value="Reset" 
           onclick="reset()" />
</div>
<script src="<util:applicationRoot/>/resources/d3.v4.min.js"></script>
<script>
	
var tokens = "${param.tgrep}".match(/[\[]|[^ \[\]]+|[\]]/g);

var fence = 0;
var treeData = parse_tokens();
var autoset = true;

	function parse_tokens() {
		var current = {};
		if (tokens[fence] == "[") {
			fence++;
			current.name = tokens[fence]; //.match(/[A-Z$]+|[^A-Z$]/g)[0];
			fence++;
		}
		while (tokens[fence] != "]") {
			if (current.children == null)
				current.children = [];
			if (tokens[fence] == "[") {
				current.children.push(parse_tokens());
				fence++;
			} else {
				var node = {};
				node.name = tokens[fence]; //.match(/[A-Z$]+|[^A-Z$]+/g)[0];
				current.children.push(node);
				fence++;
			}
		}
		return current;
	}
	
	var overall_width = 660;
	var overall_height = 200;
	
	if ("${param.width}") {
		overall_width = parseInt("${param.width}");
	}
	if ("${param.height}") {
	    overall_height = parseInt("${param.height}");
	}

	var margin = {
		top : 40,
		right : 90,
		bottom : 50,
		left : 90
	};
	var width = overall_width - margin.left - margin.right
	var height = overall_height - margin.top - margin.bottom;

	var treemap = d3.tree()
	               .size([width, height])
                    .separation(function(a,b){          // added to have even seperation of nodes in levels
                        return a.parrent==b.parrent?1:1
                        	    });

	var root = d3.hierarchy(treeData);
	var nodes = treemap(root);

	var svg = d3.select("#tree").append("svg").attr("width",
			width + margin.left + margin.right).attr("height",
			height + margin.top + margin.bottom), g = svg.append("g").attr(
			"transform", "translate(" + margin.left + "," + margin.top + ")");

	var link = g.selectAll(".link").data(nodes.descendants().slice(1)).enter()
			.append("path").attr("class", "link").attr(
					"d",
					function(d) {
						return "M" + d.x + "," + d.y + "C" + d.x + ","
								+ (d.y + d.parent.y) / 2 + " " + d.parent.x
								+ "," + (d.y + d.parent.y) / 2 + " "
								+ d.parent.x + "," + d.parent.y;
					});

	var node = g.selectAll(".node").data(nodes.descendants()).enter().append(
			"g").attr("class", function(d) {
		return "node" + (d.children ? " node--internal" : " node--leaf");
	}).on("click", click).attr("transform", function(d) {
		return "translate(" + d.x + "," + d.y + ")";
	});

	node.append("circle").attr("r", 10);

	node.append("text")
		  .attr("dy", ".35em")
		  .style("text-anchor", "middle")
		  .attr("y", function(d) {return d.children ? -20 : 20;  })
		  .text(function(d) { return d.data.name; });

	function click(d) {
		var selected = d
		while (d.parent) {
			var parent = d.parent
			var child = d
			d3.selectAll(".node").filter(
					function(e) {
						return (e == parent && !parent.selected == "1")
								|| (e == child && !child.selected == "1");
					}).select("circle").style("fill", "#FFBDA5")
			d.tagged = '1'
			d.parent.tagged = '1'
			d = d.parent;
		}
		d3.selectAll(".node").filter(function(e) {
			return e == selected;
		}).select("circle").style("fill", "#FF5313")
		selected.selected = 1
		tgrep = ""
		check(nodes)
		document.getElementById("tgrep").value = tgrep
		matches = [];
		populateMatchVector(root);
		flag()
	}

	var tgrep = "";
	var matches = [];

	function check(d) {
		console.log(d.data.name + " " + d.selected + " " + d.tagged);
		if (d.selected) {
			tgrep += "(" + d.data.name.replace(/:.*/, "") + ")";
		}
		if (d.tagged && !d.selected) {
			tgrep += d.data.name.replace(/:.*/, "");
		}
		if (!d.parent) {
			tgrep += " ^";
		}
		if (d.children)
			for (var i = 0; i < d.children.length; i++) {
				if (d.children[i].selected) {
					tgrep += " <" + (i + 1);
					check(d.children[i]);
				} else if (d.children[i].tagged) {
					tgrep += " <" + (i + 1) + "[";
					check(d.children[i]);
					tgrep += "]";
				}
			}
	}
	
	function flag() {
		if (!autoset)
			return;
		if (matches.length == 1) {
			document.getElementById("mode_promote").checked = true;
		} else if (matches.length == 2) {
            document.getElementById("mode_store").checked = true;

            if (matches[0].data.name.endsWith(":Person"))
                document.getElementById("slot0_person_id").checked = true;
            else if (matches[0].data.name.endsWith(":Organization"))
                document.getElementById("slot0_organization_id").checked = true;
            else if (matches[0].data.name.endsWith(":Support"))
                document.getElementById("slot0_support_id").checked = true;
            else if (matches[0].data.name.endsWith(":Grant"))
                document.getElementById("slot0_award_id").checked = true;
            else if (matches[0].data.name.endsWith(":Collaboration"))
                document.getElementById("slot0_collaboration_id").checked = true;

            if (matches[1].data.name.endsWith(":Collaboration"))
                document.getElementById("slot1_collaboration_id").checked = true;
            else if (matches[1].data.name.endsWith(":Organization"))
                document.getElementById("slot1_organization_id").checked = true;
            else if (matches[1].data.name.endsWith(":Resource"))
                document.getElementById("slot1_resource_id").checked = true;
            else if (matches[1].data.name.endsWith(":Technique"))
                document.getElementById("slot1_technique_id").checked = true;
            else if (matches[1].data.name.endsWith(":Grant"))
                document.getElementById("slot1_award_id").checked = true;
            else if (matches[1].data.name.endsWith(":Person"))
                document.getElementById("slot1_person_id").checked = true;
            
            if (matches[0].data.name.endsWith(":Person") && matches[1].data.name.endsWith(":Collaboration"))
                document.getElementById("relation_collaborator").checked = true;
            else if (matches[0].data.name.endsWith(":Person") && matches[1].data.name.endsWith(":Organization"))
                document.getElementById("relation_affiliation").checked = true;
            else if (matches[0].data.name.endsWith(":Person") && matches[1].data.name.endsWith(":Technique"))
                document.getElementById("relation_skill").checked = true;
            else if (matches[0].data.name.endsWith(":Person") && matches[1].data.name.endsWith(":Resource"))
                document.getElementById("relation_provider").checked = true;
            
            if (matches[0].data.name.endsWith(":Collaboration") && matches[1].data.name.endsWith(":Person"))
                document.getElementById("relation_collaborator").checked = true;
            else if (matches[0].data.name.endsWith(":Collaboration") && matches[1].data.name.endsWith(":Organization"))
                document.getElementById("relation_collaborant").checked = true;
            
            if (matches[0].data.name.endsWith(":Organization") && matches[1].data.name.endsWith(":Person"))
                document.getElementById("relation_affiliation").checked = true;
            else if (matches[0].data.name.endsWith(":Organization") && matches[1].data.name.endsWith(":Grant"))
                document.getElementById("relation_funder").checked = true;
            else if (matches[0].data.name.endsWith(":Organization") && matches[1].data.name.endsWith(":Collaboration"))
                document.getElementById("relation_collaborant").checked = true;
            else if (matches[0].data.name.endsWith(":Organization") && matches[1].data.name.endsWith(":Support"))
                document.getElementById("relation_supporter").checked = true;
            
            if (matches[0].data.name.endsWith(":Resource") && matches[1].data.name.endsWith(":Person"))
                document.getElementById("relation_provider").checked = true;
            
            if (matches[0].data.name.endsWith(":Technique") && matches[1].data.name.endsWith(":Person"))
                document.getElementById("relation_skill").checked = true;
            
            if (matches[0].data.name.endsWith(":Support") && matches[1].data.name.endsWith(":Organization"))
                document.getElementById("relation_supporter").checked = true;
            
            if (matches[0].data.name.endsWith(":Grant") && matches[1].data.name.endsWith(":Organization"))
                document.getElementById("relation_funder").checked = true;
            
            if (matches[0].data.name.endsWith(":Grant") && matches[1].data.name.endsWith(":Person"))
                document.getElementById("relation_awardee").checked = true;
		} else {
            document.getElementById("mode_instantiate").checked = true;
            document.getElementById("relation_person").checked = true;
            reset_slot0();
            reset_slot1();
        }
	}

	function reset(){
        d3.selectAll(".node")
            .select("circle").style("fill", "white");
        deletedata(root); //starts at root then calls again for each child 
        document.getElementById("tgrep").value = "";
        matches = [];
        document.getElementById("mode_instantiate").checked = false;
        document.getElementById("mode_promote").checked = false;
        document.getElementById("mode_store").checked = false;
        
        reset_relation();
        reset_slot0();
        reset_slot1();
    }

    function reset_relation() {
        document.getElementById("relation_organization").checked = false;
        document.getElementById("relation_person").checked = false;
        document.getElementById("relation_award").checked = false;
        document.getElementById("relation_collaborator").checked = false;
        document.getElementById("relation_discipline").checked = false;
        document.getElementById("relation_resource").checked = false;
        document.getElementById("relation_event").checked = false;
        document.getElementById("relation_location").checked = false;
        document.getElementById("relation_collaboration").checked = false;
        document.getElementById("relation_affiliation").checked = false;
        document.getElementById("relation_provider").checked = false;
        document.getElementById("relation_technique").checked = false;
        document.getElementById("relation_support").checked = false;
        document.getElementById("relation_skill").checked = false;
        document.getElementById("relation_project").checked = false;
        document.getElementById("relation_organic_chemical").checked = false;
        document.getElementById("relation_author").checked = false;
        document.getElementById("relation_disease").checked = false;
        document.getElementById("relation_funder").checked = false;
        document.getElementById("relation_organism").checked = false;
        document.getElementById("relation_awardee").checked = false;
        document.getElementById("relation_supporter").checked = false;
        document.getElementById("relation_publication_component").checked = false;
        document.getElementById("relation_investigator").checked = false;
        document.getElementById("relation_collaborant").checked = false;
        document.getElementById("relation_program").checked = false;
    }

    function reset_slot0(){
        document.getElementById("slot0_person_id").checked = false;
        document.getElementById("slot0_organization_id").checked = false;
        document.getElementById("slot0_support_id").checked = false;
        document.getElementById("slot0_award_id").checked = false;
        document.getElementById("slot0_collaboration_id").checked = false;
	}

    function reset_slot1(){
        document.getElementById("slot1_person_id").checked = false;
        document.getElementById("slot1_organization_id").checked = false;
        document.getElementById("slot1_award_id").checked = false;
        document.getElementById("slot1_collaboration_id").checked = false;
        document.getElementById("slot1_resource_id").checked = false;
        document.getElementById("slot1_technique_id").checked = false;
	}
	
    function populateMatchVector(d){
        if (d.selected)
        	matches.push(d);
        if (d.children){
            for (var i = 0; i < d.children.length; i++){
            	populateMatchVector(d.children[i]);
            }
        }
    }
    
    function deletedata(d){
        delete d.tagged;
        delete d.selected;
        if (d.children){
            for (var i = 0; i < d.children.length; i++){
                deletedata(d.children[i]);
            }
        }
    }
</script>
</div>