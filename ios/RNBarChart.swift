//
//  RNBarChart.swift
//  RCTIOSCharts
//
//  Created by Jose Padilla on 12/24/15.
//  Copyright © 2015 Facebook. All rights reserved.
//

import Foundation
import Charts
import SwiftyJSON

@objc(RNBarChart)
class RNBarChart : BarChartView {
  
  var labels: [String] = [];
  var values: [Double] = [];
  var dataSetLabel: String = "";
  var colors: [UIColor] = ChartColorTemplates.colorful();
  var descriptionFontName: String = "HelveticaNeue";
  var descriptionFontSize: CGFloat = 9.0;
  var infoTextFontName: String = "HelveticaNeue";
  var infoTextFontSize: CGFloat = 12.0;
  var legendTextFontName: String = "HelveticaNeue";
  var legendTextFontSize: CGFloat = 12.0;
  
  override init(frame: CGRect) {
    super.init(frame: frame);
    self.frame = frame;
    self.descriptionText = "";
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  }
  
  func setConfig(config: String!) {
    var json: JSON = nil;
    if let data = config.dataUsingEncoding(NSUTF8StringEncoding) {
      json = JSON(data: data);
    };
    
    if json["labels"].isExists() {
      self.labels = json["labels"].arrayObject as! [String];
    }
    
    if json["values"].isExists() {
      self.values = json["values"].arrayObject as! [Double];
    }
    
    if json["backgroundColor"].isExists() {
      self.backgroundColor = RCTConvert.UIColor(json["backgroundColor"].intValue);
    }
    
    if json["gridBackgroundColor"].isExists() {
      self.gridBackgroundColor = RCTConvert.UIColor(json["gridBackgroundColor"].intValue);
    }
    
    if json["noDataText"].isExists() {
      self.noDataText = json["noDataText"].stringValue;
    }
    
    if json["descriptionText"].isExists() {
      self.descriptionText = json["descriptionText"].stringValue;
    }
    
    if json["descriptionFontName"].isExists() {
      self.descriptionFontName = json["descriptionFontName"].stringValue;

      self.descriptionFont = UIFont(
        name: self.descriptionFontName,
        size: self.descriptionFontSize
      );
    }
    
    if json["descriptionFontSize"].isExists() {
      self.descriptionFontSize = CGFloat(json["descriptionFontSize"].floatValue);
      
      self.descriptionFont = UIFont(
        name: self.descriptionFontName,
        size: self.descriptionFontSize
      );
    }
    
    if json["descriptionTextColor"].isExists() {
      self.descriptionTextColor = RCTConvert.UIColor(json["descriptionTextColor"].intValue);
    }
    
    if json["descriptionTextPosition"].isExists() &&
       json["descriptionTextPosition"]["x"].isExists() &&
       json["descriptionTextPosition"]["y"].isExists() {
        
        self.setDescriptionTextPosition(
          x: CGFloat(json["descriptionTextPosition"]["x"].floatValue),
          y: CGFloat(json["descriptionTextPosition"]["y"].floatValue)
        )
    }
    
    if json["infoTextFontName"].isExists() {
      self.infoTextFontName = json["infoTextFontName"].stringValue;
      
      self.infoFont = UIFont(
        name: self.infoTextFontName,
        size: self.infoTextFontSize
      );
    }
    
    if json["infoTextFontSize"].isExists() {
      self.infoTextFontSize = CGFloat(json["infoTextFontSize"].floatValue);
      
      self.infoFont = UIFont(
        name: self.infoTextFontName,
        size: self.infoTextFontSize
      );
    }
    
    if json["infoTextColor"].isExists() {
      self.infoTextColor = RCTConvert.UIColor(json["infoTextColor"].intValue);
    }
    
    if json["dataSetLabel"].isExists() {
      self.dataSetLabel = json["dataSetLabel"].stringValue;
    }
    
    if json["colors"].isExists() {
      let arrColors = json["colors"].arrayObject as! [Int];
      self.colors = arrColors.map({return RCTConvert.UIColor($0)});
    }
    
    if json["showBackgroundGrid"].isExists() {
      self.leftAxis.drawGridLinesEnabled = json["showBackgroundGrid"].boolValue;
      self.rightAxis.drawGridLinesEnabled = json["showBackgroundGrid"].boolValue;
      self.xAxis.drawGridLinesEnabled = json["showBackgroundGrid"].boolValue;
    }

    if json["descriptionTextAlign"].isExists() {
      switch (json["descriptionTextAlign"].stringValue) {
        case "left":
          self.descriptionTextAlign = NSTextAlignment.Left;
          break;
        case "center":
          self.descriptionTextAlign = NSTextAlignment.Center;
          break;
        case "right":
          self.descriptionTextAlign = NSTextAlignment.Right;
          break;
        case "justified":
          self.descriptionTextAlign = NSTextAlignment.Justified;
          break;
        default:
          break;
      }
    }
    
    if json["drawBorders"].isExists() {
      self.drawBordersEnabled = json["drawBorders"].boolValue;
    }
    
    if json["borderColor"].isExists() {
      self.borderColor = RCTConvert.UIColor(json["borderColor"].intValue);
    }
    
    if json["borderLineWidth"].isExists() {
      self.borderLineWidth = CGFloat(json["borderLineWidth"].floatValue);
    }
    
    if json["drawMarkers"].isExists() {
      self.drawMarkers = json["drawMarkers"].boolValue;
    }
    
    if json["drawValueAboveBar"].isExists() {
      self.drawValueAboveBarEnabled = json["drawValueAboveBar"].boolValue;
    }
    
    if json["drawHighlightArrow"].isExists() {
      self.drawHighlightArrowEnabled = json["drawHighlightArrow"].boolValue;
    }
    
    if json["drawBarShadow"].isExists() {
      self.drawBarShadowEnabled = json["drawBarShadow"].boolValue;
    }

    if json["minOffset"].isExists() {
      self.minOffset = CGFloat(json["minOffset"].floatValue);
    }
    
    if json["autoScaleMinMax"].isExists() {
      self.autoScaleMinMaxEnabled = json["autoScaleMinMax"].boolValue;
    }
    
    if json["highlightPerTap"].isExists() {
      self.highlightPerTapEnabled = json["highlightPerTap"].boolValue;
    }
    
    if json["showLegend"].isExists() {
      self.legend.enabled = json["showLegend"].boolValue;
    }
    
    if json["legend"].isExists() {
      if json["legend"]["textColor"].isExists() {
        self.legend.textColor = RCTConvert.UIColor(json["legend"]["textColor"].intValue);
      }
      
      if json["legend"]["textSize"].isExists() {
        self.legendTextFontSize = CGFloat(json["legend"]["textSize"].floatValue);
        self.legend.font = UIFont(
          name: self.legendTextFontName,
          size: self.legendTextFontSize
        )!;
      }
      
      if json["legend"]["typeface"].isExists() {
        self.legendTextFontName = json["legend"]["typeface"].stringValue;
        self.legend.font = UIFont(
          name: self.legendTextFontName,
          size: self.legendTextFontSize
          )!;
      }
      
      if json["legend"]["wordWrap"].isExists() {
        self.legend.wordWrapEnabled = json["legend"]["wordWrap"].boolValue;
      }
      
      if json["legend"]["maxSizePercent"].isExists() {
        self.legend.maxSizePercent = CGFloat(json["legend"]["maxSizePercent"].floatValue);
      }
      
      if json["legend"]["position"].isExists() {
        switch(json["legend"]["position"].stringValue) {
          case "rightOfChart":
            self.legend.position = ChartLegend.ChartLegendPosition.RightOfChart;
            break;
          case "rightOfChartCenter":
            self.legend.position = ChartLegend.ChartLegendPosition.RightOfChartCenter;
            break;
          case "rightOfChartInside":
            self.legend.position = ChartLegend.ChartLegendPosition.RightOfChartInside;
            break;
          case "leftOfChart":
            self.legend.position = ChartLegend.ChartLegendPosition.LeftOfChart;
            break;
          case "leftOfChartCenter":
            self.legend.position = ChartLegend.ChartLegendPosition.LeftOfChartCenter;
            break;
          case "leftOfChartInside":
            self.legend.position = ChartLegend.ChartLegendPosition.LeftOfChartInside;
            break;
          case "belowChartLeft":
            self.legend.position = ChartLegend.ChartLegendPosition.BelowChartLeft;
            break;
          case "belowChartRight":
            self.legend.position = ChartLegend.ChartLegendPosition.BelowChartRight;
            break;
          case "belowChartCenter":
            self.legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter;
            break;
          case "aboveChartLeft":
            self.legend.position = ChartLegend.ChartLegendPosition.AboveChartLeft;
            break;
          case "aboveChartRight":
            self.legend.position = ChartLegend.ChartLegendPosition.AboveChartRight;
            break;
          case "aboveChartCenter":
            self.legend.position = ChartLegend.ChartLegendPosition.AboveChartCenter;
            break;
          case "pieChartCenter":
            self.legend.position = ChartLegend.ChartLegendPosition.PiechartCenter;
            break;
          default:
            self.legend.position = ChartLegend.ChartLegendPosition.BelowChartLeft;
            break;
        }
      }
      
      
      
    }
    
    if self.values.count > 0 && self.labels.count > 0 {
      setChart();
    }
    
  }
  
  func setChart() {
    var dataEntries: [BarChartDataEntry] = [];
    
    for i in 0..<self.values.count {
      let dataEntry = BarChartDataEntry(value: values[i], xIndex: i);
      dataEntries.append(dataEntry);
    }
    
    let chartDataSet = BarChartDataSet(yVals: dataEntries, label: self.dataSetLabel);
    let chartData = BarChartData(xVals: self.labels, dataSet: chartDataSet);
    self.data = chartData;
    
    chartDataSet.colors = self.colors;
    
    self.xAxis.labelPosition = .Bottom;
    
    //        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//    self.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
    
//    let ll = ChartLimitLine(limit: 10.0, label: "Target")
//    self.rightAxis.addLimitLine(ll)
    
  }

}