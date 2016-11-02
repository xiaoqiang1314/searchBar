//
//  ViewController.m
//  searchBar
//
//  Created by strong on 2016/10/22.
//  Copyright © 2016年 strong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UISearchBarDelegate,UITableViewDataSource>
/**<#描述#>*/
@property (nonatomic, strong) NSArray *dataArr;
/**<#描述#>*/
@property (nonatomic, strong) NSArray *searchArr;
/**<#描述#>*/
@property (nonatomic, assign) BOOL isSearch;
/**<#描述#>*/
@property (nonatomic, strong) UITableView *tab;
/**<#描述#>*/
@property (nonatomic, strong) UISearchBar *serBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSearch = NO;
    self.dataArr = [NSArray arrayWithObjects:
                    @"Java讲义",
                    @"轻量级Java EE企业应用实战",
                    @"Android讲义",
                    @"Ajax讲义",
                    @"HTML5/CSS3/JavaScript讲义",
                    @"iOS讲义",
                    @"XML讲义",
                    @"经典Java EE企业应用实战"
                    @"Java入门与精通",
                    @"Java基础教程",
                    @"学习Java",
                    @"Objective-C基础" ,
                    @"Ruby入门与精通",
                    @"iOS开发教程" ,nil];
    // 创建UISearchBar对象
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 100, 60)];
    _serBar = searchBar;
//    searchBar.backgroundColor = [UIColor redColor];
    // 设置Prompt提示
//    [searchBar setPrompt:@"查找图书"];
    // 设置没有输入时的提示占位符
    [searchBar setPlaceholder:@"请输入图书名字"];
//    // 显示Cancel按钮
//    searchBar.showsCancelButton = true;
    // 设置代理
    searchBar.delegate = self;
    
    
    // 创建UITableView
    _tab = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    // 设置代理
    _tab.dataSource = self;
    
    //设置 searchBar 为 table 的头部视图
    _tab.tableHeaderView = searchBar;
    // 添加UITableView
    [self.view addSubview:_tab];
}
#pragma mark - UITableViewDataSource

// 返回表格分区数，默认返回1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // 如果处于搜索状态
    if(self.isSearch)
    {
        // 使用searchData作为表格显示的数据
        return self.searchArr.count;
    }
    else
    {
        // 否则使用原始的tableData座位表格显示的数据
        return self.dataArr.count;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"----cellForRowAtIndexPath------");
    
    static NSString* cellId = @"cellId";
    // 从可重用的表格行队列中获取表格行
    UITableViewCell* cell = [tableView
                             dequeueReusableCellWithIdentifier:cellId];
    // 如果表格行为nil
    if(!cell)
    {
        // 创建表格行
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    // 获取当前正在处理的表格行的行号
    NSInteger rowNo = indexPath.row;
    // 如果处于搜索状态
    if(self.isSearch)
    {
        // 使用searchData作为表格显示的数据
        cell.textLabel.text = [self.searchArr objectAtIndex:rowNo];
    }
    else{
        // 否则使用原始的tableData作为表格显示的数据
        cell.textLabel.text = [_dataArr objectAtIndex:rowNo];
    }
    return cell;
}
#pragma mark - UISearchBarDelegate

// UISearchBarDelegate定义的方法，用户单击取消按钮时激发该方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarCancelButtonClicked------");
    // 取消搜索状态
    self.isSearch = NO;
    [self.tab reloadData];
    [self.serBar resignFirstResponder];
    self.serBar.showsCancelButton =NO;
}

// UISearchBarDelegate定义的方法，当搜索文本框内文本改变时激发该方法
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    NSLog(@"----textDidChange------");
    // 调用filterBySubstring:方法执行搜索
    [self filterBySubstring:searchText];
}

// UISearchBarDelegate定义的方法，用户单击虚拟键盘上Search按键时激发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarSearchButtonClicked------");
    // 调用filterBySubstring:方法执行搜索
    [self filterBySubstring:searchBar.text];
    // 放弃作为第一个响应者，关闭键盘
    [searchBar resignFirstResponder];
    self.serBar.showsCancelButton =NO;
}

- (void) filterBySubstring:(NSString*) subStr
{
    NSLog(@"----filterBySubstring------");
    // 设置为搜索状态
    self.isSearch = YES;
    // 显示Cancel按钮
    self.serBar.showsCancelButton = true;
    // 定义搜索谓词
    NSPredicate* pred = [NSPredicate predicateWithFormat:
                         @"SELF CONTAINS[c] %@" , subStr];
    // 使用谓词过滤NSArray
    self.searchArr = [self.dataArr filteredArrayUsingPredicate:pred];
    // 让表格控件重新加载数据
    [self.tab reloadData];
}
@end
