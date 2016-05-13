//
//  ViewController.m
//  CoreData
//
//  Created by Mouse on 16/5/12.
//  Copyright © 2016年 新果教育. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Student.h"
@interface ViewController ()

@property(nonatomic,strong)NSManagedObjectContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、上下文 使用上下文 添加数据 删除数据 查找数据 跟新数据
    
    NSManagedObjectContext *ctx =[[NSManagedObjectContext alloc]init];
    
    //4、创建管理模型
    //添加一个.xcdatamodeld文件到模型管理器中
   // [NSManagedObjectModel mergedModelFromBundles:(nullable NSArray<NSBundle *> *) forStoreMetadata:(nonnull NSDictionary<NSString *,id> *)]
    
    //查找项目中所有的.xcdatamodeld 文件 添加到模型管理器中
    NSManagedObjectModel*modelMgr =[NSManagedObjectModel mergedModelFromBundles:nil];
    
    
    //3、创建持久存储器对象
    
    NSPersistentStoreCoordinator *store =[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:modelMgr];
    //设置路径
    
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString*path =[doc stringByAppendingString:@"xmg.sqlite"];
    
    //存储数据类型的类型和数据
    
    NSError *error =nil ;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    
    NSLog(@"%@",path);
    if (error) {
        NSLog(@"存储器有问题");
    }
    
    
    //2、设置上下文的持久存储器
    ctx.persistentStoreCoordinator =store;
   
    self.context =ctx;

    
    // Do any additional setup after loading the view, typically from a nib.
}

//添加
- (IBAction)Add:(id)sender {
//    Student*stu =[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context ];
//    
//    stu.name =@"xmg1";
//    stu.age = [NSDate date];
//    stu.height = @1.75;
//    NSError *error =nil;
//    [self.context save:&error];
//    if (!error) {
//        NSLog(@"添加数据成功");
//    }
    
    for (int i =0; i<15; i++) {
            Student*stu =[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context ];
        
        stu.name = [NSString stringWithFormat:@"godFive%d",i];
        stu.age = [NSDate date];
            stu.height = @(1.75+i);
            NSError *error =nil;
            [self.context save:&error];
            if (!error) {
                NSLog(@"添加数据成功");
            }

    }
    
    
    
}
//删除
- (IBAction)Dele:(id)sender {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name = %@",@"godFive1"];
    
    
    request.predicate =predicate;
    
    NSError *error = nil;
    
    NSArray*datas =[self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        for (Student *stu in datas) {
            [self.context deleteObject:stu];
            [self.context save:nil];
        }
    }
    
    
}
//查找
- (IBAction)Search:(id)sender {
    //创建一个获取数据对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    //设置过滤条件
    
//    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name = %@",@"godFive1"];
//    request.predicate =predicate;
    //升序
    NSSortDescriptor*sort =[NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    request.sortDescriptors =@[sort];
    
    
    NSError *error = nil;
 NSArray *datas =  [self.context executeFetchRequest:request error:&error];
  
    if (!error) {
        
        NSLog(@"datas ===%@",datas);
        
        for (Student*stu in datas) {
            NSLog(@"%@    %@  %@",stu.name,stu.height,stu.age);
        }
        
    }
    
    
    
}
//修改
- (IBAction)updata:(id)sender {
    
    //查找到对应的数据进行修改
    
    NSFetchRequest*request =[NSFetchRequest fetchRequestWithEntityName:@"Student"];
    NSPredicate*predicate =[NSPredicate predicateWithFormat:@"height = %@",@1.75];
    request.predicate =predicate;
    NSError *error = nil;
  NSArray* datas =   [self.context executeFetchRequest:request error:&error];
    
    
    if (!error) {
        for (Student*stu in datas) {
            
            stu.height = @1.1;
            //保存导数据库
            [self.context save:nil];
        }
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
