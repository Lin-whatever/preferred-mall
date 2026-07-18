package com.ecpbm.util;

import com.ecpbm.pojo.TreeNode;
import java.util.ArrayList;
import java.util.List;

/**
 * 构建EasyUI Tree所需的树形结构数据
 */
public class JsonFactory {

    /**
     * 递归构建树形结构
     * @param nodes 所有节点列表
     * @param id 父节点ID（初始为0，对应根节点）
     * @return 构建好的树形节点列表
     */
    public static List<TreeNode> buildtree(List<TreeNode> nodes, int id) {
        List<TreeNode> treeNodes = new ArrayList<>();
        for (TreeNode treeNode : nodes) {
            TreeNode node = new TreeNode();
            node.setId(treeNode.getId());
            node.setText(treeNode.getText());
            // 匹配当前父节点ID，递归构建子节点
            if (id == treeNode.getFid()) {
                node.setChildren(buildtree(nodes, node.getId()));
                treeNodes.add(node);
            }
        }
        return treeNodes;
    }
}