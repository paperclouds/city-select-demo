//
//  CitySelectController.m
//  CitySelectDemo
//
//  Created by paperclouds on 2018/5/28.
//  Copyright © 2018年 hechang. All rights reserved.
//

#import "CitySelectController.h"
#import "CityCollectionCell.h"
#import <MBProgressHUD.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]

static NSString *collectionCellID = @"collectionCellID";

@interface CitySelectController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *allCities; //全部城市
@property (nonatomic, copy) NSArray *hotCities; //热门城市
@property (nonatomic, strong) NSMutableArray *allCityNames; //全部城市名字

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CitySelectController

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityGroups" ofType:@"plist"]];
    }
    return _dataArray;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, (self.hotCities.count/3==0?self.hotCities.count/3:self.hotCities.count/3+1)*40) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGBA(0xf7f7f7, 1);
    self.title = @"城市选择";
    
    [self initData];
    
    [self createUI];
    
}

- (void)initData{
    _allCities = [NSMutableArray new];
    _hotCities = [NSArray new];
    _allCityNames = [NSMutableArray new];
    for (NSDictionary *dic in self.dataArray) {
        if (![dic[@"title"] isEqualToString:@"热门"]) {
            for (NSString *cityName in dic[@"cities"]) {
                [self.allCityNames addObject:cityName];
            }
            [self.allCities addObject:dic];
        }else{
            self.hotCities = dic[@"cities"];
        }
    }
}

- (void)createUI{
    [self.collectionView registerClass:[CityCollectionCell class] forCellWithReuseIdentifier:collectionCellID];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allCities.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        NSArray *cities = self.allCities[section-1][@"cities"];
        return cities.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *newCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"new"];
        [newCell addSubview:self.collectionView];
        return newCell;
    }else{
        NSDictionary *dic = _allCities[indexPath.section - 1];
        cell.textLabel.text = dic[@"cities"][indexPath.row];
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"热门城市";
    }else{
        return self.allCities[section-1][@"title"];
    }
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"热门"];
    for (NSDictionary *dic in self.allCities) {
        [arr addObject:dic[@"title"]];
    }
    return arr;
}

#pragma mark 索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //点击索引，列表跳转到对应索引的行
    if (index == 0) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index-1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
        [self showMessage:title toView:self.view];
    return index;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (self.hotCities.count/3==0?self.hotCities.count/3:self.hotCities.count/3+1)*40;
    }else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        NSString *cityName = [NSString new];
        NSDictionary *dic = self.allCities[indexPath.section - 1];
        cityName = dic[@"cities"][indexPath.row];
        self.selectCity(cityName);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _hotCities.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[CityCollectionCell alloc]initWithFrame:CGRectZero];
    }
    cell.titleLbl.text = self.hotCities[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.frame.size.width/3-20, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout =
    (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectCity(_hotCities[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 显示索引信息
- (void)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows  lastObject];
    }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.label.text = message;
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:0.7];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
