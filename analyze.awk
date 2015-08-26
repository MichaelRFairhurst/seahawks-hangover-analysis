# Run with `awk games.csv -F, -f analyze.awk`
#
# games.csv was scraped with this javascript snippet:
# var e = document.querySelectorAll('.new-score-box'); function z(k) {return k.querySelector('a').href.slice(38) + "," + k.querySelector(".total-score").text(); } for(var i = 0; i < e.length; i++) { console.log(z(e[i].querySelector('.team-wrapper:nth-child(2)')) + "," + z(e[i].querySelector('.team-wrapper:nth-child(1)'))); }

BEGIN {
	#state = "gatherTeamTotals"
	state = "calculate"

	pointsallowed["WAS"] = 916
	pointsscored["WAS"] = 635
	pointsallowed["OAK"] = 905
	pointsscored["OAK"] = 575
	pointsallowed["CLE"] = 743
	pointsscored["CLE"] = 607
	pointsallowed["DEN"] = 753
	pointsscored["DEN"] = 1088
	pointsallowed["GB"] = 776
	pointsscored["GB"] = 903
	pointsallowed["SEA"] = 485
	pointsscored["SEA"] = 811
	pointsallowed["BAL"] = 654
	pointsscored["BAL"] = 729
	pointsallowed["TB"] = 799
	pointsscored["TB"] = 565
	pointsallowed["DET"] = 658
	pointsscored["DET"] = 716
	pointsallowed["MIA"] = 708
	pointsscored["MIA"] = 705
	pointsallowed["HOU"] = 735
	pointsscored["HOU"] = 648
	pointsallowed["PIT"] = 738
	pointsscored["PIT"] = 815
	pointsallowed["CIN"] = 649
	pointsscored["CIN"] = 795
	pointsallowed["ARI"] = 623
	pointsscored["ARI"] = 689
	pointsallowed["BUF"] = 677
	pointsscored["BUF"] = 682
	pointsallowed["CAR"] = 615
	pointsscored["CAR"] = 705
	pointsallowed["PHI"] = 782
	pointsscored["PHI"] = 916
	pointsallowed["NE"] = 651
	pointsscored["NE"] = 912
	pointsallowed["NYG"] = 783
	pointsscored["NYG"] = 674
	pointsallowed["MIN"] = 823
	pointsscored["MIN"] = 716
	pointsallowed["DAL"] = 784
	pointsscored["DAL"] = 906
	pointsallowed["IND"] = 705
	pointsscored["IND"] = 849
	pointsallowed["SD"] = 696
	pointsscored["SD"] = 744
	pointsallowed["TEN"] = 819
	pointsscored["TEN"] = 616
	pointsallowed["NYJ"] = 788
	pointsscored["NYJ"] = 573
	pointsallowed["CHI"] = 920
	pointsscored["CHI"] = 764
	pointsallowed["KC"] = 586
	pointsscored["KC"] = 783
	pointsallowed["STL"] = 718
	pointsscored["STL"] = 672
	pointsallowed["SF"] = 612
	pointsscored["SF"] = 712
	pointsallowed["ATL"] = 860
	pointsscored["ATL"] = 734
	pointsallowed["JAC"] = 861
	pointsscored["JAC"] = 496
	pointsallowed["NO"] = 728
	pointsscored["NO"] = 815
}

/[A-Z]/ {

	priorOpponentOf1 = priorOpponents[$1]
	priorOpponentOf2 = priorOpponents[$3]
	priorOpponents[$1] = $3
	priorOpponents[$3] = $1

	if(state == "gatherTeamTotals") {
		pointsallowed[$1] += $4
		pointsallowed[$3] += $2
		pointsscored[$1] += $2
		pointsscored[$3] += $4
	}

	if(state == "calculate") {
		opExpPointsAllowed[priorOpponentOf1] += pointsallowed[$1] / 32
		opExpPointsAllowed[priorOpponentOf2] += pointsallowed[$3] / 32
		opExpPointsScored[priorOpponentOf1] += pointsscored[$1] / 32
		opExpPointsScored[priorOpponentOf2] += pointsscored[$3] / 32

		opActPointsAllowed[priorOpponentOf1] += $4
		opActPointsAllowed[priorOpponentOf2] += $2
		opActPointsScored[priorOpponentOf1] += $2
		opActPointsScored[priorOpponentOf2] += $4
	}
}

/2014/ {
	delete priorOpponents
}

END {
	if(state == "gatherTeamTotals") {
		for(i in pointsallowed) {
			print "pointsallowed[\"" i "\"] = " pointsallowed[i]
			print "pointsscored[\"" i "\"] = " pointsscored[i]
		}
	}

	if(state == "calculate") {
		print "Total / TEAM / Exp Score / Actual Score / Diff / Exp Allowed / Actual Allowed / Diff"
		for(i in opExpPointsAllowed) {
			offDiff = (opActPointsScored[i] - opExpPointsScored[i])
			defDiff = (opExpPointsAllowed[i] - opActPointsAllowed[i])
			print (offDiff + defDiff) " / " i " / " opExpPointsScored[i] " / " opActPointsScored[i] " / " offDiff  " / " opExpPointsAllowed[i] " / " opActPointsAllowed[i] " / " defDiff
		}
	}
}
