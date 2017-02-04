//
//  PublishViewController.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishViewController.h"
#import "PublishTable.h"
#import "ArticleModel.h"

#import "SelectPhotoUtil.h"

#import "PublishBar.h"


@interface PublishViewController () <RefreshTableViewDelegate>


@property (nonatomic, strong) PublishTable *tableView;


// 键盘上方编辑框
@property (nonatomic, strong) PublishBar *editBar;

// 当前数据源模型
@property (nonatomic, strong) ArticleModel *articleModel;


// 当前插入图片位置
@property (nonatomic, assign) NSInteger insertIndex;
@property (nonatomic, assign) NSRange insertRange;




@end

@implementation PublishViewController


#pragma mark - Init
- (void)initTable {

    _tableView = [[PublishTable alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.refreshDelegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView updateTableDatasSource:_articleModel];

    
    B2CWeakSelf;
    _tableView.editBlock = ^(NSString *text, NSInteger tag, EditStatus editStatus, NSRange selectRange) {
    
        [weakSelf handleTextViewCallBackWithText:text index:tag editStatus:editStatus range:selectRange];
    };
 
    
    _tableView.scrollBlock = ^() {
    
        [weakSelf resetInsertLocationToEnd];
        [weakSelf.view endEditing:YES];
    };
    
    _tableView.cellDidChangeEdit = ^(CGRect textViewFrame) {
    
         [weakSelf.tableView scrollRectToVisible:textViewFrame animated:YES];
    };
}


- (void)handleTextViewCallBackWithText:(NSString*)text index:(NSInteger)index editStatus:(EditStatus)status range:(NSRange)selectRange {


    PublishModel *publishModel = _articleModel.modelList[index];
    publishModel.content = text;
    
    _insertIndex = index;
    _insertRange = selectRange;
    
    if (status == EditStatusEnd) {
        [_tableView updateTableDatasSource:_articleModel];
    }
}


- (void)initTableHeader {

    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _tableView.tableHeaderView = tableHeader;
    
    tableHeader.backgroundColor = kBackgroundColor;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth -20, 30)];
    
    [tableHeader addSubview:textView];
}

- (void)initEditBar {

    _editBar = [[PublishBar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64, kScreenWidth, 40)];
 
    [self.view addSubview:_editBar];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"写文章"];
    
    
    if (_articleModel == nil) {
        _articleModel = [[ArticleModel alloc] init];
        
        PublishModel *publishModel = [[PublishModel alloc] init];
        [_articleModel.modelList addObject:publishModel];
    }
    
    
    [UIBarButtonItem addRightItemWithImageName:@"close_ic" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(insertImage:)];
    
    [self initTable];
    
    [self initTableHeader];
    

    [self addKeyBoardNotification];
    
    
    [self initEditBar];
}

- (void)addKeyBoardNotification {
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidHidden:)
                                                 name:UIKeyboardWillHideNotification                                              object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardFrameChange:)
                                                 name:UIKeyboardWillChangeFrameNotification                                             object:nil];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    // 1.当用户还未写文章前，点击空白地方，响应文章详情textView
    if (_articleModel.modelList.count == 1) {

        PublishTextCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.textField becomeFirstResponder];
    }
}

#pragma mark - Private
- (void)resetInsertLocationToEnd {

    _insertIndex = _articleModel.modelList.count -1;
    
    PublishModel *publishModel = _articleModel.modelList.lastObject;
    _insertRange = NSMakeRange(publishModel.content.length, 0);
}


#pragma mark - Event
- (void)handleKeyboardFrameChange:(NSNotification*)notification {

    NSDictionary *userInfo = notification.userInfo;
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardY = rect.origin.y;
    keyboardY = ABS(keyboardY - kScreenHeight) > 0.1 ? keyboardY: keyboardY + 40;
    
    
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat offsetY = keyboardY - self.view.frame.size.height - 64 - 40;

        _editBar.transform = CGAffineTransformMakeTranslation(0, offsetY);
    }];
    
}

- (void)handleKeyboardDidShow:(NSNotification*)notification {

    
//    NSDictionary *userInfo = notification.userInfo;
//    
//    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取键盘高度

    //_tableView.contentInset = UIEdgeInsetsMake(0, 0,rect.size.height, 0);
}

- (void)handleKeyboardDidHidden:(NSNotification*)notificaiton {
    
    _tableView.contentInset = UIEdgeInsetsZero;
}


- (void)insertImage:(UIButton*)btn {

    [self.view endEditing:YES];
    
    SelectPhotoUtil *photoUtil = [SelectPhotoUtil shareInstance];
    
    [photoUtil selectImageViewWithViewController:self success:^(UIImage *image) {
       
        
        // 获取当前正在编辑的模型
        PublishModel *publishModel = _articleModel.modelList[_insertIndex];
        
        
        // 2.分隔编辑模型的文字
        NSString *content = publishModel.content;
        NSInteger location = _insertRange.location;
        
        NSString *leftContent = [content substringToIndex:location];
        NSString *nextString = [content substringFromIndex:location];
        
        publishModel.content = leftContent;
        
        
        // 1.创建新的模型, 把上上模型的图片，存到下一个模型
        PublishModel *newModel = [[PublishModel alloc] init];
        newModel.image = publishModel.image;
        newModel.imgUrl = publishModel.imgUrl;
        
        newModel.content = nextString;

        [_articleModel.modelList insertObject:newModel atIndex:_insertIndex+1];
        
        
        // 3.设置当前模型图片图片
        publishModel.image = image;
        publishModel.imgUrl = @"testimgur";
        
        
        [_tableView updateTableDatasSource:_articleModel];
        
        // 4.设置添加图片到结尾位置
        [self resetInsertLocationToEnd];
    }];
}


#pragma mark - RefreshTableViewDelegate
- (void)refreshTableView:(BaseTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  
    PublishModel *publishModel = _articleModel.modelList[(indexPath.row-1)/2];
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"是否 替换/删除 此图片" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        SelectPhotoUtil *photoUtil = [SelectPhotoUtil shareInstance];
        
        [photoUtil selectImageViewWithViewController:self success:^(UIImage *image) {
            
            
            publishModel.image = image;
            publishModel.imgUrl = @"testImg";
            
            [_tableView updateTableDatasSource:_articleModel];
        }];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        publishModel.image = nil;
        publishModel.imgUrl = nil;
        
        [_tableView updateTableDatasSource:_articleModel];
    }];
  
    
    // [deleteAction setValue:[UIColor redColor] forKey:@"titleTextColor"];

    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertCtrl addAction:changeAction];
    [alertCtrl addAction:deleteAction];
    [alertCtrl addAction:cancleAction];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)refreshTableViewButtonClick:(BaseTableView *)refreshTableview WithButton:(UIButton *)sender SelectRowAtIndex:(NSInteger)index {

    
    
}



@end
